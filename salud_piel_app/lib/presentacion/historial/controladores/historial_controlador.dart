import 'package:get/get.dart';

import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../nucleo/utilidades/resultado.dart';

class HistorialControlador extends GetxController {
  final DiagnosticoCasoUso _casoUso;

  HistorialControlador({required DiagnosticoCasoUso casoUso})
      : _casoUso = casoUso;

  final analisis = <Diagnostico>[].obs;
  final cargando = true.obs;

  @override
  void onInit() {
    super.onInit();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    cargando.value = true;
    final resultado = await _casoUso.listarDiagnosticos();
    switch (resultado) {
      case Exito<List<Diagnostico>>():
        analisis.value = resultado.data;
      case Fracaso<List<Diagnostico>>():
        Get.snackbar('Error', resultado.mensaje, snackPosition: SnackPosition.BOTTOM);
    }
    cargando.value = false;
  }

  Future<void> agregarAnalisis(Diagnostico diagnostico) async {
    final resultado = await _casoUso.guardarDiagnostico(diagnostico);
    switch (resultado) {
      case Exito<int>():
        analisis.insert(0, diagnostico);
      case Fracaso<int>():
        Get.snackbar('Error', resultado.mensaje, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
