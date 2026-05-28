import 'package:get/get.dart';

import 'bienvenida_controlador.dart';

class BienvenidaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BienvenidaControlador>(() => BienvenidaControlador(), fenix: true);
  }
}
