import 'package:get/get.dart';

import '../../rutas/app_rutas.dart';

class BienvenidaControlador extends GetxController {
  void irALogin() => Get.toNamed(AppRutas.login);
  void irARegistro() => Get.toNamed(AppRutas.registro);
}
