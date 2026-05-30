import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../dominio/entidades/producto.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';
import '../../dominio/enumeraciones/tipo_piel.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';

class InformacionCondicion {
  final String descripcion;
  final List<String> causas;
  final String? recomendacionDermatologo;
  final List<String> consejosCuidado;

  InformacionCondicion({
    required this.descripcion,
    required this.causas,
    this.recomendacionDermatologo,
    required this.consejosCuidado,
  });
}

class ProductoRecomendado {
  final String nombre;
  final String? marca;
  final String? categoria;
  final String? descripcion;
  final String? comoUsar;
  final String? tipoPiel;
  final String? condicion;
  final String motivoRecomendacion;

  ProductoRecomendado({
    required this.nombre,
    this.marca,
    this.categoria,
    this.descripcion,
    this.comoUsar,
    this.tipoPiel,
    this.condicion,
    required this.motivoRecomendacion,
  });
}

class RutinaPersonalizada {
  final List<String> pasosDia;
  final List<String> pasosNoche;
  final List<ProductoRecomendado> productosRecomendados;
  final String consejosAdicionales;

  RutinaPersonalizada({
    required this.pasosDia,
    required this.pasosNoche,
    required this.productosRecomendados,
    required this.consejosAdicionales,
  });
}

class DetalleProductoIA {
  final String explicacionIngredientes;
  final List<String> beneficios;
  final String idealPara;
  final String? advertencias;
  final double ratingIA;

  DetalleProductoIA({
    required this.explicacionIngredientes,
    required this.beneficios,
    required this.idealPara,
    this.advertencias,
    required this.ratingIA,
  });
}

class GeminiServicio extends GetxService {
  GenerativeModel? _model;

  GenerativeModel? get _modelo {
    if (_model != null) return _model;
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'tu_api_key_de_gemini_aqui') {
      return null;
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3,
        responseMimeType: 'application/json',
      ),
    );
    return _model;
  }

  Future<InformacionCondicion?> informacionCondicion({
    required CondicionPiel condicion,
    double confianza = 0.0,
  }) async {
    final modelo = _modelo;
    if (modelo == null) return null;

    final conectado = await _tieneInternet();
    if (!conectado) return null;

    final prompt = '''
Eres un dermatólogo virtual. Dada la condición de piel "${condicion.displayName}" con ${(confianza * 100).round()}% de confianza, proporciona información útil.

Responde SOLO con JSON sin markdown ni caracteres de escape:
{
  "descripcion": "Descripción breve y clara de la condición en español (~3-5 oraciones)",
  "causas": ["Causa 1", "Causa 2", "Causa 3"],
  "recomendacionDermatologo": "Si es severo o preocupante, indica cuándo acudir al dermatólogo. Si es leve, indica que puede manejarse con cuidado diario.",
  "consejosCuidado": ["Consejo 1", "Consejo 2", "Consejo 3"]
}
''';

    try {
      final response = await modelo.generateContent([Content.text(prompt)]);
      final texto = response.text;
      if (texto == null || texto.isEmpty) return null;

      final json = jsonDecode(texto) as Map<String, dynamic>;
      return InformacionCondicion(
        descripcion: json['descripcion'] as String? ?? '',
        causas: (json['causas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        recomendacionDermatologo: json['recomendacionDermatologo'] as String?,
        consejosCuidado: (json['consejosCuidado'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
    } catch (_) {
      return null;
    }
  }

  Future<RutinaPersonalizada?> rutinaPersonalizada({
    required String tipoPiel,
    required List<String> condicionesDetectadas,
    int? edad,
    String? sexo,
    String? condicionesMedicas,
    double? confianzaTipoPiel,
  }) async {
    final modelo = _modelo;
    if (modelo == null) return null;

    final conectado = await _tieneInternet();
    if (!conectado) return null;

    final condStr = condicionesDetectadas.isEmpty
        ? 'Ninguna condición visible detectada'
        : condicionesDetectadas.join(', ');
    final edadStr = edad != null ? '$edad años' : 'No especificada';
    final sexoStr = sexo ?? 'No especificado';
    final medStr = condicionesMedicas ?? 'Ninguna';
    final confStr = confianzaTipoPiel != null
        ? '${(confianzaTipoPiel * 100).round()}%'
        : 'No disponible';

    final prompt = '''
Eres un dermatólogo virtual. Genera una rutina personalizada de cuidado facial.

Datos del usuario:
- Tipo de piel: $tipoPiel (confianza: $confStr)
- Condiciones detectadas en el rostro: $condStr
- Edad: $edadStr
- Sexo: $sexoStr
- Condiciones médicas preexistentes: $medStr

Responde SOLO con JSON sin markdown:
{
  "pasosDia": ["Paso 1 de rutina matutina", "Paso 2", ...],
  "pasosNoche": ["Paso 1 de rutina nocturna", "Paso 2", ...],
  "productosRecomendados": [
    {
      "nombre": "Nombre del producto",
      "marca": "Marca (o null)",
      "categoria": "limpiador/hidratante/protector solar/serum/exfoliante/etc",
      "descripcion": "Descripción breve del producto",
      "comoUsar": "Cómo aplicar este producto",
      "tipoPiel": "grasa/seca/mixta/normal",
      "condicion": "acne/manchas/poros/etc (o null si aplica a todas)",
      "motivoRecomendacion": "Por qué recomiendas este producto para este usuario"
    }
  ],
  "consejosAdicionales": "Consejos generales adicionales en español"
}
''';

    try {
      final response = await modelo.generateContent([Content.text(prompt)]);
      final texto = response.text;
      if (texto == null || texto.isEmpty) return null;

      final json = jsonDecode(texto) as Map<String, dynamic>;

      final productosRaw =
          (json['productosRecomendados'] as List<dynamic>?) ?? [];
      final productos = productosRaw.map((e) {
        final m = e as Map<String, dynamic>;
        return ProductoRecomendado(
          nombre: m['nombre'] as String? ?? '',
          marca: m['marca'] as String?,
          categoria: m['categoria'] as String?,
          descripcion: m['descripcion'] as String?,
          comoUsar: m['comoUsar'] as String?,
          tipoPiel: m['tipoPiel'] as String?,
          condicion: m['condicion'] as String?,
          motivoRecomendacion: m['motivoRecomendacion'] as String? ?? '',
        );
      }).toList();

      _guardarProductosRecomendados(productos);

      return RutinaPersonalizada(
        pasosDia:
            (json['pasosDia'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        pasosNoche:
            (json['pasosNoche'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        productosRecomendados: productos,
        consejosAdicionales: json['consejosAdicionales'] as String? ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  Future<DetalleProductoIA?> detalleProductoIA(Producto producto) async {
    final modelo = _modelo;
    if (modelo == null) return null;

    final conectado = await _tieneInternet();
    if (!conectado) return null;

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
      final response = await modelo.generateContent([Content.text(prompt)]);
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
    } catch (_) {
      return null;
    }
  }

  Future<void> _guardarProductosRecomendados(List<ProductoRecomendado> productos) async {
    try {
      final repo = Get.find<IProductoRepositorio>();
      for (final p in productos) {
        if (p.nombre.isEmpty) continue;
        final existente = await repo.buscarPorNombre(p.nombre);
        if (existente is Exito) continue;
        TipoPiel? tipoPiel;
        if (p.tipoPiel != null) {
          for (final t in TipoPiel.values) {
            if (t.name == p.tipoPiel) {
              tipoPiel = t;
              break;
            }
          }
        }
        CondicionPiel? condicion;
        if (p.condicion != null) {
          for (final c in CondicionPiel.values) {
            if (c.name == p.condicion || c.displayName == p.condicion) {
              condicion = c;
              break;
            }
          }
        }
        await repo.insertar(Producto(
          id: 0,
          nombre: p.nombre,
          marca: p.marca,
          categoria: p.categoria,
          descripcion: p.descripcion,
          comoUsar: p.comoUsar,
          tipoPiel: tipoPiel,
          condicion: condicion,
          esIA: true,
        ));
      }
    } catch (_) {}
  }

  Future<void> _actualizarInstruccionesIA(int productoId, DetalleProductoIA detalle) async {
    try {
      final repo = Get.find<IProductoRepositorio>();
      final resultado = await repo.obtenerPorId(productoId);
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
      await repo.actualizar(actualizado);
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
