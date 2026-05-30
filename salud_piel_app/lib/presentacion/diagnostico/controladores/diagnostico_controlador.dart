import 'package:get/get.dart';

import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../../dominio/utilidades/resultado.dart';
import '../../../nucleo/servicios/ml_servicio.dart';

class DiagnosticoControlador extends GetxController {
  final DiagnosticoCasoUso _casoUso;

  DiagnosticoControlador({
    required DiagnosticoCasoUso casoUso,
  }) : _casoUso = casoUso;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ResultadoAnalisis) {
      _cargarDesdeResultadoML(args);
    } else if (args is String && args.isNotEmpty) {
      imagenPath.value = args;
    }
  }

  final condicion = CondicionPiel.normal.obs;
  final confianza = 0.0.obs;
  final descripcion = ''.obs;
  final imagenPath = ''.obs;
  final severidad = ''.obs;
  final productosRecomendados = <Producto>[].obs;
  final guardando = false.obs;
  final deteccionesResumen = <String, int>{}.obs;

  void _cargarDesdeResultadoML(ResultadoAnalisis r) {
    condicion.value = _mapearCondicion(r.tipoPiel);
    confianza.value = r.confianzaTipoPiel;
    severidad.value = r.severidadGeneral;
    imagenPath.value = r.imagenPath;
    deteccionesResumen.value = r.conteoPorCondicion;

    final partes = <String>[];
    if (r.severidadGeneral.isNotEmpty) {
      partes.add('Severidad: ${r.severidadGeneral}');
    }
    if (r.recomendacionesDia.isNotEmpty) {
      partes.add('\n--- Rutina Día ---\n${r.recomendacionesDia.join('\n')}');
    }
    if (r.recomendacionesNoche.isNotEmpty) {
      partes.add('\n--- Rutina Noche ---\n${r.recomendacionesNoche.join('\n')}');
    }
    if (r.aclaraciones.isNotEmpty) {
      partes.add('\n${r.aclaraciones.join('\n')}');
    }
    descripcion.value = partes.join('\n');
  }

  CondicionPiel _mapearCondicion(String tipoPiel) {
    switch (tipoPiel.toLowerCase()) {
      case 'grasa':
        return CondicionPiel.acne;
      case 'seca':
        return CondicionPiel.eczema;
      case 'mixta':
        return CondicionPiel.dermatitis;
      default:
        return CondicionPiel.normal;
    }
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
    productosRecomendados.value = productos ?? [];
  }

  Future<void> guardarEnHistorial() async {
    guardando.value = true;

    final diagnostico = Diagnostico(
      id: 0,
      imagenPath: imagenPath.value,
      condicion: condicion.value,
      confianza: confianza.value,
      fecha: DateTime.now(),
      descripcion: descripcion.value.isNotEmpty ? descripcion.value : null,
      productosRecomendados: List.from(productosRecomendados),
    );

    final resultado = await _casoUso.guardarDiagnostico(diagnostico);
    switch (resultado) {
      case Exito<int>():
        Get.snackbar('Guardado', 'Diagnóstico guardado en historial.',
            snackPosition: SnackPosition.BOTTOM);
      case Fracaso<int>():
        Get.snackbar('Error', resultado.mensaje,
            snackPosition: SnackPosition.BOTTOM);
    }
    guardando.value = false;
  }
}
