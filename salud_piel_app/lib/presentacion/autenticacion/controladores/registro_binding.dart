import 'package:get/get.dart';

import 'registro_controlador.dart';
import 'sesion_controlador.dart';

class RegistroBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RegistroControlador>(RegistroControlador(
      sesionControlador: Get.find<SesionControlador>(),
    ));
  }
}
