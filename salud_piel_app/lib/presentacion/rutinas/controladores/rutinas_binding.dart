import 'package:get/get.dart';

import '../../../dominio/casos_uso/rutina_caso_uso.dart';
import '../../inicio/controladores/inicio_controlador.dart';
import 'rutinas_controlador.dart';

class RutinasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RutinasControlador>(() => RutinasControlador(
      casoUso: Get.find<RutinaCasoUso>(),
      inicioControlador: Get.find<InicioControlador>(),
    ), fenix: true);
  }
}
