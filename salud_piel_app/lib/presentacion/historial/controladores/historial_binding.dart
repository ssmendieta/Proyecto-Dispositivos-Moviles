import 'package:get/get.dart';

import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import 'historial_controlador.dart';

class HistorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistorialControlador>(() => HistorialControlador(
      casoUso: Get.find<DiagnosticoCasoUso>(),
    ), fenix: true);
  }
}
