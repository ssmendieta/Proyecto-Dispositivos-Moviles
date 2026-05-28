import 'package:get/get.dart';

import 'login_controlador.dart';
import 'sesion_controlador.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginControlador>(() => LoginControlador(
      sesionControlador: Get.find<SesionControlador>(),
    ), fenix: true);
  }
}
