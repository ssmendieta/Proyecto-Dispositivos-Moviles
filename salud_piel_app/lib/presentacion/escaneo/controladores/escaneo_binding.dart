import 'package:get/get.dart';

import '../../inicio/controladores/inicio_controlador.dart';
import 'escaneo_controlador.dart';

class EscaneoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EscaneoControlador>(() => EscaneoControlador(
      inicioControlador: Get.find<InicioControlador>(),
    ), fenix: true);
  }
}
