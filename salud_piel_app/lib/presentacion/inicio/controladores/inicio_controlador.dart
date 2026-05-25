import 'package:get/get.dart';

class InicioControlador extends GetxController {
  final indiceActual = 0.obs;

  void cambiarPagina(int indice) {
    indiceActual.value = indice;
  }
}