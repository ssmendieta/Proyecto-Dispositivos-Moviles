import 'dart:convert';

import '../../../datos/servicios/ml_servicio.dart';
import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/casos_uso/gemini_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/entidades/informacion_condicion.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../../dominio/utilidades/resultado.dart';

class ValorCompat<T> {
  T value;

  ValorCompat(this.value);
}

class ValorNuloCompat<T> {
  T? value;

  ValorNuloCompat([this.value]);
}

class DiagnosticoControlador {
  final DiagnosticoCasoUso casoUso;
  final GeminiCasoUso geminiCasoUso;

  DiagnosticoControlador({
    required this.casoUso,
    required this.geminiCasoUso,
  });

  final condicion = ValorCompat<CondicionPiel>(CondicionPiel.normal);
  final confianza = ValorCompat<double>(0.0);
  final descripcion = ValorCompat<String>('');
  final imagenPath = ValorCompat<String>('');
  final severidad = ValorCompat<String>('');
  final productosRecomendados = <Producto>[];
  final guardando = ValorCompat<bool>(false);
  final deteccionesResumen = <String, int>{};

  final informacionCondicion = ValorNuloCompat<InformacionCondicion>();
  final cargandoInfoIA = ValorCompat<bool>(false);

  final tituloResultado = ValorCompat<String>('');

  void cargarDesdeResultadoML(ResultadoAnalisis resultado) {
    final tieneDetecciones = resultado.detecciones.isNotEmpty;

    tituloResultado.value = tieneDetecciones
        ? resultado.condicionPrincipal
        : 'Sin condición visible';

    confianza.value = tieneDetecciones
        ? resultado.confianzaCondicionPrincipal
        : resultado.confianzaTipoPiel;

    condicion.value = _mapearCondicionPorTexto(tituloResultado.value);
    severidad.value = resultado.severidadGeneral;
    imagenPath.value = resultado.imagenPath;

    deteccionesResumen
      ..clear()
      ..addAll(resultado.conteoPorCondicion);

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

    descripcion.value = partes.join('\n');
  }

  Future<void> cargarInformacionIA() async {
    cargandoInfoIA.value = true;
    informacionCondicion.value = null;

    final info = await geminiCasoUso.obtenerInformacionCondicion(
      condicion.value,
      confianza: confianza.value,
    );

    informacionCondicion.value = info;
    cargandoInfoIA.value = false;
  }

  void cargarResultado({
    required CondicionPiel cond,
    required double conf,
    String? desc,
    String? imgPath,
    List<Producto>? productos,
  }) {
    condicion.value = cond;
    confianza.value = conf;
    descripcion.value = desc ?? '';
    imagenPath.value = imgPath ?? '';

    productosRecomendados
      ..clear()
      ..addAll(productos ?? []);
  }

  Future<void> guardarEnHistorial() async {
    guardando.value = true;

    String? contextoIAJson;

    final info = informacionCondicion.value;
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
      imagenPath: imagenPath.value,
      condicion: condicion.value,
      confianza: confianza.value,
      fecha: DateTime.now(),
      descripcion: descripcion.value.isNotEmpty ? descripcion.value : null,
      contextoIA: contextoIAJson,
      productosRecomendados: List<Producto>.from(productosRecomendados),
    );

    final resultado = await casoUso.guardarDiagnostico(diagnostico);

    switch (resultado) {
      case Exito<int>():
        break;

      case Fracaso<int>():
        break;
    }

    guardando.value = false;
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