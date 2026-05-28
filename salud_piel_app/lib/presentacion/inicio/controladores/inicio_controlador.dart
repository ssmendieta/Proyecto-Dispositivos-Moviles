import 'package:get/get.dart';

import '../../rutas/app_rutas.dart';

class InicioControlador extends GetxController {
  final indiceActual = 0.obs;

  void irAHistorial() => Get.toNamed(AppRutas.historial);

  void cambiarPagina(int indice) {
    indiceActual.value = indice;
  }
}
