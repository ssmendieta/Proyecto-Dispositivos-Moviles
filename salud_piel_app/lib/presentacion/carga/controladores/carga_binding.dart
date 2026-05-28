import 'package:get/get.dart';

import '../../autenticacion/controladores/sesion_controlador.dart';
import 'carga_controlador.dart';

class CargaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CargaControlador>(CargaControlador(
      sesionControlador: Get.find<SesionControlador>(),
    ));
  }
}
