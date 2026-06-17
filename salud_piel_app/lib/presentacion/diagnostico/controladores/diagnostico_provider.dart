import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../datos/providers/dependencias_provider.dart';
import '../../../datos/servicios/ml_servicio.dart';
import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/casos_uso/gemini_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/entidades/informacion_condicion.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../../dominio/utilidades/resultado.dart';

class DiagnosticoEstado {
  final CondicionPiel condicion;
  final double confianza;
  final String descripcion;
  final String imagenPath;
  final String severidad;
  final List<Producto> productosRecomendados;
  final bool guardando;
  final Map<String, int> deteccionesResumen;
  final InformacionCondicion? informacionCondicion;
  final bool cargandoInfoIA;
  final String tituloResultado;
  final bool resultadoCargado;

  const DiagnosticoEstado({
    required this.condicion,
    required this.confianza,
    required this.descripcion,
    required this.imagenPath,
    required this.severidad,
    required this.productosRecomendados,
    required this.guardando,
    required this.deteccionesResumen,
    required this.informacionCondicion,
    required this.cargandoInfoIA,
    required this.tituloResultado,
    required this.resultadoCargado,
  });

  static const _sinCambios = Object();

  DiagnosticoEstado copyWith({
    CondicionPiel? condicion,
    double? confianza,
    String? descripcion,
    String? imagenPath,
    String? severidad,
    List<Producto>? productosRecomendados,
    bool? guardando,
    Map<String, int>? deteccionesResumen,
    Object? informacionCondicion = _sinCambios,
    bool? cargandoInfoIA,
    String? tituloResultado,
    bool? resultadoCargado,
  }) {
    return DiagnosticoEstado(
      condicion: condicion ?? this.condicion,
      confianza: confianza ?? this.confianza,
      descripcion: descripcion ?? this.descripcion,
      imagenPath: imagenPath ?? this.imagenPath,
      severidad: severidad ?? this.severidad,
      productosRecomendados:
          productosRecomendados ?? this.productosRecomendados,
      guardando: guardando ?? this.guardando,
      deteccionesResumen: deteccionesResumen ?? this.deteccionesResumen,
      informacionCondicion: informacionCondicion == _sinCambios
          ? this.informacionCondicion
          : informacionCondicion as InformacionCondicion?,
      cargandoInfoIA: cargandoInfoIA ?? this.cargandoInfoIA,
      tituloResultado: tituloResultado ?? this.tituloResultado,
      resultadoCargado: resultadoCargado ?? this.resultadoCargado,
    );
  }
}

class DiagnosticoNotifier extends StateNotifier<DiagnosticoEstado> {
  final DiagnosticoCasoUso _casoUso;
  final GeminiCasoUso _geminiCasoUso;

  DiagnosticoNotifier({
    required DiagnosticoCasoUso casoUso,
    required GeminiCasoUso geminiCasoUso,
  })  : _casoUso = casoUso,
        _geminiCasoUso = geminiCasoUso,
        super(
          const DiagnosticoEstado(
            condicion: CondicionPiel.normal,
            confianza: 0.0,
            descripcion: '',
            imagenPath: '',
            severidad: '',
            productosRecomendados: [],
            guardando: false,
            deteccionesResumen: {},
            informacionCondicion: null,
            cargandoInfoIA: false,
            tituloResultado: '',
            resultadoCargado: false,
          ),
        );

  void cargarDesdeResultadoML(ResultadoAnalisis resultado) {
    final tieneDetecciones = resultado.detecciones.isNotEmpty;

    final titulo = tieneDetecciones
        ? resultado.condicionPrincipal
        : 'Sin condición visible';

    final confianza = tieneDetecciones
        ? resultado.confianzaCondicionPrincipal
        : resultado.confianzaTipoPiel;

    final partes = <String>[];

    partes.add(
      'Tipo de piel estimado: ${_capitalizar(resultado.tipoPiel)} (${(resultado.confianzaTipoPiel * 100).round()}%).',
    );

    if (resultado.severidadGeneral.isNotEmpty) {
      partes.add('Severidad: ${resultado.severidadGeneral}');
    }

    if (resultado.recomendacionesDia.isNotEmpty) {
      partes.add(
        '\nRutina Día\n${resultado.recomendacionesDia.join('\n')}',
      );
    }

    if (resultado.recomendacionesNoche.isNotEmpty) {
      partes.add(
        '\nRutina Noche\n${resultado.recomendacionesNoche.join('\n')}',
      );
    }

    if (resultado.aclaraciones.isNotEmpty) {
      partes.add(
        '\n${resultado.aclaraciones.join('\n')}',
      );
    }

    state = state.copyWith(
      tituloResultado: titulo,
      confianza: confianza,
      condicion: _mapearCondicionPorTexto(titulo),
      severidad: resultado.severidadGeneral,
      imagenPath: resultado.imagenPath,
      deteccionesResumen: resultado.conteoPorCondicion,
      descripcion: partes.join('\n'),
      resultadoCargado: true,
      informacionCondicion: null,
    );
  }

  void cargarResultado({
    required CondicionPiel cond,
    required double conf,
    String? desc,
    String? imgPath,
    List<Producto>? productos,
  }) {
    state = state.copyWith(
      condicion: cond,
      confianza: conf,
      descripcion: desc ?? '',
      imagenPath: imgPath ?? '',
      productosRecomendados: productos ?? [],
      resultadoCargado: true,
      informacionCondicion: null,
    );
  }

  Future<void> cargarInformacionIA() async {
    if (!state.resultadoCargado) {
      return;
    }

    state = state.copyWith(
      cargandoInfoIA: true,
      informacionCondicion: null,
    );

    final info = await _geminiCasoUso.obtenerInformacionCondicion(
      state.condicion,
      confianza: state.confianza,
    );

    state = state.copyWith(
      informacionCondicion: info ?? _fallbackCondicion(state.condicion),
      cargandoInfoIA: false,
    );
  }

  Future<String?> guardarEnHistorial() async {
    state = state.copyWith(
      guardando: true,
    );

    String? contextoIAJson;

    final info = state.informacionCondicion;
    if (info != null) {
      contextoIAJson = jsonEncode({
        'descripcion': info.descripcion,
        'causas': info.causas,
        'recomendacionDermatologo': info.recomendacionDermatologo,
        'consejosCuidado': info.consejosCuidado,
      });
    }

    final diagnostico = Diagnostico(
      id: 0,
      imagenPath: state.imagenPath,
      condicion: state.condicion,
      confianza: state.confianza,
      fecha: DateTime.now(),
      descripcion: state.descripcion.isNotEmpty ? state.descripcion : null,
      contextoIA: contextoIAJson,
      productosRecomendados: List<Producto>.from(
        state.productosRecomendados,
      ),
    );

    final resultado = await _casoUso.guardarDiagnostico(diagnostico);

    switch (resultado) {
      case Exito<int>():
        state = state.copyWith(
          guardando: false,
        );
        return null;

      case Fracaso<int>():
        state = state.copyWith(
          guardando: false,
        );
        return resultado.mensaje;
    }
  }

  InformacionCondicion _fallbackCondicion(CondicionPiel condicion) {
    switch (condicion) {
      case CondicionPiel.acne:
        return InformacionCondicion(
          descripcion:
              'El acné es una afección cutánea que aparece cuando los poros se obstruyen con sebo, células muertas o bacterias. Puede presentarse como puntos negros, puntos blancos, granitos o lesiones inflamadas.',
          causas: [
            'Exceso de producción de grasa en la piel.',
            'Obstrucción de los poros por células muertas.',
            'Cambios hormonales, estrés o uso de productos comedogénicos.',
          ],
          recomendacionDermatologo:
              'Consulta con un dermatólogo si el acné es persistente, doloroso, deja marcas o no mejora con cuidados básicos.',
          consejosCuidado: [
            'Lava el rostro dos veces al día con un limpiador suave.',
            'Evita manipular o exprimir los granitos.',
            'Usa productos no comedogénicos y protector solar oil-free.',
          ],
        );

      case CondicionPiel.eczema:
        return InformacionCondicion(
          descripcion:
              'El eczema es una inflamación de la piel que puede causar sequedad, picazón, enrojecimiento y descamación.',
          causas: [
            'Alteración de la barrera protectora de la piel.',
            'Reacción a irritantes, alérgenos o clima seco.',
            'Predisposición genética o sensibilidad cutánea.',
          ],
          recomendacionDermatologo:
              'Consulta si la picazón es intensa, si hay heridas, secreción, costras o si afecta tu descanso.',
          consejosCuidado: [
            'Hidrata la piel con cremas sin fragancia.',
            'Evita jabones agresivos y agua muy caliente.',
            'Usa ropa suave y evita rascar la zona afectada.',
          ],
        );

      case CondicionPiel.rosacea:
        return InformacionCondicion(
          descripcion:
              'La rosácea es una condición crónica que suele causar enrojecimiento facial, sensibilidad, ardor y vasos sanguíneos visibles.',
          causas: [
            'Dilatación de vasos sanguíneos en el rostro.',
            'Sensibilidad a sol, calor, alcohol, picantes o estrés.',
            'Respuesta inflamatoria de la piel.',
          ],
          recomendacionDermatologo:
              'Consulta si el enrojecimiento es frecuente, persistente o aparece con ardor, granitos o irritación.',
          consejosCuidado: [
            'Usa protector solar todos los días.',
            'Evita productos con alcohol, fragancia o exfoliantes fuertes.',
            'Identifica y evita factores que desencadenen brotes.',
          ],
        );

      case CondicionPiel.melasma:
        return InformacionCondicion(
          descripcion:
              'El melasma es una hiperpigmentación que aparece como manchas oscuras, generalmente en mejillas, frente, nariz o labio superior.',
          causas: [
            'Exposición solar sin protección adecuada.',
            'Cambios hormonales.',
            'Predisposición genética y tipo de piel.',
          ],
          recomendacionDermatologo:
              'Consulta si las manchas aumentan, se oscurecen o no mejoran con protección solar constante.',
          consejosCuidado: [
            'Usa protector solar FPS 50+ diariamente.',
            'Evita exposición directa al sol.',
            'No uses despigmentantes fuertes sin supervisión profesional.',
          ],
        );

      case CondicionPiel.psoriasis:
        return InformacionCondicion(
          descripcion:
              'La psoriasis es una enfermedad inflamatoria crónica que puede producir placas rojizas, gruesas y descamativas.',
          causas: [
            'Respuesta alterada del sistema inmunológico.',
            'Predisposición genética.',
            'Estrés, infecciones, clima frío o lesiones en la piel.',
          ],
          recomendacionDermatologo:
              'Consulta con un dermatólogo si hay placas extensas, dolor, descamación intensa o molestias articulares.',
          consejosCuidado: [
            'Mantén la piel hidratada.',
            'Evita rascar o retirar escamas con fuerza.',
            'Identifica factores que empeoran los brotes.',
          ],
        );

      case CondicionPiel.dermatitis:
        return InformacionCondicion(
          descripcion:
              'La dermatitis es una inflamación de la piel que puede causar enrojecimiento, ardor, picazón, sequedad o descamación.',
          causas: [
            'Contacto con irritantes o alérgenos.',
            'Uso de productos agresivos.',
            'Sensibilidad cutánea o reacción inflamatoria.',
          ],
          recomendacionDermatologo:
              'Consulta si la dermatitis se extiende, duele, se infecta o aparece repetidamente.',
          consejosCuidado: [
            'Evita el producto o sustancia que provoque irritación.',
            'Usa jabones suaves e hidratantes sin fragancia.',
            'Protege la piel de químicos o detergentes fuertes.',
          ],
        );

      case CondicionPiel.normal:
        return InformacionCondicion(
          descripcion:
              'No se observan condiciones visibles relevantes en la imagen analizada. El resultado es orientativo y puede variar según la iluminación y calidad de la foto.',
          causas: [
            'La piel parece mantenerse sin alteraciones visibles importantes.',
            'Una buena hidratación y protección solar ayudan a conservar la barrera cutánea.',
          ],
          recomendacionDermatologo:
              'Mantén controles si notas cambios nuevos, manchas, lesiones persistentes o molestias.',
          consejosCuidado: [
            'Limpieza suave diaria.',
            'Hidratación adecuada.',
            'Protector solar todos los días.',
          ],
        );

      case CondicionPiel.otro:
        return InformacionCondicion(
          descripcion:
              'Se identificó una condición cutánea que no corresponde claramente a una categoría específica. El análisis es orientativo.',
          causas: [
            'Puede relacionarse con irritación, sensibilidad, exposición solar, cambios hormonales o factores ambientales.',
            'La calidad de la imagen puede influir en el resultado.',
          ],
          recomendacionDermatologo:
              'Consulta con un dermatólogo para una evaluación precisa, especialmente si hay dolor, picazón, inflamación o empeoramiento.',
          consejosCuidado: [
            'Evita manipular la zona afectada.',
            'Usa productos suaves y sin fragancia.',
            'Protege la piel del sol y observa cambios.',
          ],
        );
    }
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) {
      return texto;
    }

    return texto[0].toUpperCase() + texto.substring(1).toLowerCase();
  }

  CondicionPiel _mapearCondicionPorTexto(String texto) {
    final t = texto.toLowerCase();

    if (t.contains('acn') || t.contains('acne')) {
      return CondicionPiel.acne;
    }

    if (t.contains('mancha') ||
        t.contains('dark') ||
        t.contains('spot') ||
        t.contains('melasma')) {
      return CondicionPiel.melasma;
    }

    if (t.contains('rojez') ||
        t.contains('redness') ||
        t.contains('enrojecimiento') ||
        t.contains('rosacea')) {
      return CondicionPiel.rosacea;
    }

    if (t.contains('eczema')) {
      return CondicionPiel.eczema;
    }

    if (t.contains('psoriasis')) {
      return CondicionPiel.psoriasis;
    }

    if (t.contains('dermatitis')) {
      return CondicionPiel.dermatitis;
    }

    if (t.contains('sin condición') || t.contains('normal')) {
      return CondicionPiel.normal;
    }

    return CondicionPiel.otro;
  }
}

final diagnosticoProvider =
    StateNotifierProvider.autoDispose<DiagnosticoNotifier, DiagnosticoEstado>(
  (ref) {
    return DiagnosticoNotifier(
      casoUso: ref.watch(diagnosticoCasoUsoProvider),
      geminiCasoUso: ref.watch(geminiCasoUsoProvider),
    );
  },
);