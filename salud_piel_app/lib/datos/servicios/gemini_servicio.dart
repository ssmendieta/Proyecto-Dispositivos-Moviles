import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../dominio/entidades/detalle_producto_ia.dart';
import '../../dominio/entidades/informacion_condicion.dart';
import '../../dominio/entidades/producto.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';
import '../../dominio/repositorios/i_gemini_servicio.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';

class _PendingRequest<T> {
  final Future<T> Function() fn;
  final Completer<T> completer;
  _PendingRequest(this.fn, this.completer);
}

class GeminiServicio implements IGeminiServicio {
  final IProductoRepositorio _repositorio;
  GenerativeModel? _model;
  @override
  String? ultimoError;
  bool _enEjecucion = false;
  final _cola = <_PendingRequest>[];
  final _apiKeys = <String>[];
  int _keyIndex = 0;

  GeminiServicio({required IProductoRepositorio repositorio})
      : _repositorio = repositorio {
    _cargarKeys();
  }

  void _cargarKeys() {
    for (int i = 1;; i++) {
      final key = dotenv.env['GEMINI_API_KEY${i == 1 ? '' : '_$i'}'];
      if (key == null || key.isEmpty || key == 'tu_api_key_de_gemini_aqui') break;
      _apiKeys.add(key);
    }
    if (_apiKeys.isEmpty) {
      final key = dotenv.env['GEMINI_API_KEY'];
      if (key != null && key.isNotEmpty && key != 'tu_api_key_de_gemini_aqui') {
        _apiKeys.add(key);
      }
    }
  }

  void _rotarKey() {
    _model = null;
    _keyIndex = (_keyIndex + 1) % _apiKeys.length;
  }

  Future<T> _ejecutarConCola<T>(Future<T> Function() fn) async {
    final completer = Completer<T>();
    _cola.add(_PendingRequest<T>(fn, completer));
    await _procesarCola();
    return completer.future;
  }

  Future<void> _procesarCola() async {
    if (_enEjecucion || _cola.isEmpty) return;
    _enEjecucion = true;
    final pendiente = _cola.removeAt(0);
    try {
      final resultado = await pendiente.fn();
      if (!pendiente.completer.isCompleted) {
        pendiente.completer.complete(resultado);
      }
    } catch (e) {
      if (!pendiente.completer.isCompleted) {
        pendiente.completer.completeError(e);
      }
    } finally {
      _enEjecucion = false;
      _procesarCola();
    }
  }

  Future<T> _reintentarConBackoff<T>(Future<T> Function() fn, {int maxIntentos = 3}) async {
    for (int i = 0; i < maxIntentos; i++) {
      try {
        return await fn();
      } catch (e) {
        final mensaje = e.toString();
        if (mensaje.contains('429') || mensaje.contains('RESOURCE_EXHAUSTED') || mensaje.contains('quota')) {
          _rotarKey();
          if (i < maxIntentos - 1) {
            await Future.delayed(Duration(seconds: (i + 1) * 2));
            continue;
          }
        }
        rethrow;
      }
    }
    throw Exception('Máximo de reintentos alcanzado');
  }

  GenerativeModel? get _modelo {
    if (_model != null) return _model;
    if (_apiKeys.isEmpty) return null;
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKeys[_keyIndex],
      generationConfig: GenerationConfig(
        temperature: 0.3,
        responseMimeType: 'application/json',
      ),
    );
    return _model;
  }

  @override
  Future<InformacionCondicion?> informacionCondicion({
    required CondicionPiel condicion,
    double confianza = 0.0,
  }) async {
    return _ejecutarConCola(() => _informacionCondicion(condicion: condicion, confianza: confianza));
  }

  Future<InformacionCondicion?> _informacionCondicion({
    required CondicionPiel condicion,
    double confianza = 0.0,
  }) async {
    final modelo = _modelo;
    if (modelo == null) {
      ultimoError = 'API key de Gemini no configurada. Revisa tu archivo .env';
      return null;
    }

    final conectado = await _tieneInternet();
    if (!conectado) {
      ultimoError = 'Sin conexión a internet. Verifica tu conexión e intenta de nuevo.';
      return null;
    }

    final prompt = '''
Eres un dermatólogo virtual. Dada la condición de piel "${condicion.displayName}" con ${(confianza * 100).round()}% de confianza, proporciona información útil.

Responde SOLO con JSON sin markdown ni caracteres de escape:
{
  "descripcion": "Descripción breve y clara de la condición en español (~3-5 oraciones). Incluye qué es y cómo se manifiesta.",
  "causas": [
    "Explicación detallada de la causa principal de por qué se produce esta condición (factores genéticos, ambientales, estilo de vida, etc.)",
    "Segunda causa importante con su explicación",
    "Tercera causa relevante"
  ],
  "recomendacionDermatologo": "Indica cuándo es necesario acudir al dermatólogo según la severidad y qué señales de alerta considerar.",
  "consejosCuidado": ["Consejo práctico 1 para el cuidado diario", "Consejo 2", "Consejo 3"]
}

IMPORTANTE: En "causas", explica NO solo el nombre de la causa sino POR QUÉ ocurre y qué factores la desencadenan. Por ejemplo: "El acné se produce cuando los poros se obstruyen con sebo y células muertas, lo que permite la proliferación de bacterias Cutibacterium acnes, desencadenando inflamación. Los factores hormonales, el estrés y ciertos alimentos pueden agravarlo."
''';

    try {
      final response = await _reintentarConBackoff(() => modelo.generateContent([Content.text(prompt)]));
      final texto = response.text;
      if (texto == null || texto.isEmpty) return null;

      final json = jsonDecode(texto) as Map<String, dynamic>;
      return InformacionCondicion(
        descripcion: json['descripcion'] as String? ?? '',
        causas: (json['causas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        recomendacionDermatologo: json['recomendacionDermatologo'] as String?,
        consejosCuidado: (json['consejosCuidado'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
    } catch (e) {
      ultimoError = 'Error al consultar Gemini: $e';
      return null;
    }
  }

  @override
  Future<DetalleProductoIA?> detalleProductoIA(Producto producto) async {
    return _ejecutarConCola(() => _detalleProductoIA(producto));
  }

  Future<DetalleProductoIA?> _detalleProductoIA(Producto producto) async {
    final modelo = _modelo;
    if (modelo == null) {
      ultimoError = 'API key de Gemini no configurada. Revisa tu archivo .env';
      return null;
    }

    final conectado = await _tieneInternet();
    if (!conectado) {
      ultimoError = 'Sin conexión a internet. Verifica tu conexión e intenta de nuevo.';
      return null;
    }

    final prompt = '''
Eres un dermatólogo virtual. Analiza el siguiente producto de cuidado facial y proporciona información detallada generada por IA.

Producto:
- Nombre: ${producto.nombre}
- Marca: ${producto.marca ?? 'No especificada'}
- Categoría: ${producto.categoria ?? 'No especificada'}
- Descripción: ${producto.descripcion ?? 'No disponible'}
- Ingredientes: ${producto.ingredientes ?? 'No disponibles'}
- Tipo de piel recomendado: ${producto.tipoPiel?.name ?? 'No especificado'}
- Condición que trata: ${producto.condicion?.displayName ?? 'No especificada'}
- Modo de uso: ${producto.comoUsar ?? 'No disponible'}

Responde SOLO con JSON sin markdown:
{
  "explicacionIngredientes": "Explicación breve de los ingredientes clave y por qué funcionan (~3-5 oraciones en español)",
  "beneficios": ["Beneficio 1", "Beneficio 2", "Beneficio 3"],
  "idealPara": "Descripción de para qué tipo de piel y condiciones es ideal este producto",
  "advertencias": "Posibles contraindicaciones o irritantes (o null si no aplica)",
  "ratingIA": 4.2
}

Reglas para ratingIA:
- Calificación de 1.0 a 5.0 basada en ingredientes, seguridad y efectividad.
- 4.5-5.0: Excelente, ingredientes bien investigados, pocos irritantes.
- 3.5-4.4: Bueno, adecuado para mayoría.
- 2.5-3.4: Aceptable, puede tener fragancias/alcohol/secantes.
- 1.0-2.4: Contiene irritantes potenciales o ingredientes cuestionables.
''';

    try {
      final response = await _reintentarConBackoff(() => modelo.generateContent([Content.text(prompt)]));
      final texto = response.text;
      if (texto == null || texto.isEmpty) return null;

      final json = jsonDecode(texto) as Map<String, dynamic>;

      final detalle = DetalleProductoIA(
        explicacionIngredientes: json['explicacionIngredientes'] as String? ?? '',
        beneficios:
            (json['beneficios'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        idealPara: json['idealPara'] as String? ?? '',
        advertencias: json['advertencias'] as String?,
        ratingIA: (json['ratingIA'] as num?)?.toDouble() ?? 0.0,
      );

      await _actualizarInstruccionesIA(producto.id, detalle);

      return detalle;
    } catch (e) {
      ultimoError = 'Error al consultar Gemini: $e';
      return null;
    }
  }

  Future<void> _actualizarInstruccionesIA(int productoId, DetalleProductoIA detalle) async {
    try {
      final resultado = await _repositorio.obtenerPorId(productoId);
      if (resultado is! Exito) return;
      final producto = (resultado as Exito<Producto>).data;
      final actualizado = producto.copyWith(
        instruccionesIA: jsonEncode({
          'explicacionIngredientes': detalle.explicacionIngredientes,
          'beneficios': detalle.beneficios,
          'idealPara': detalle.idealPara,
          'advertencias': detalle.advertencias,
          'ratingIA': detalle.ratingIA,
        }),
        esIA: true,
      );
      await _repositorio.actualizar(actualizado);
    } catch (_) {}
  }

  Future<bool> _tieneInternet() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}
