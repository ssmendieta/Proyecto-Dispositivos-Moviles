import 'package:get/get.dart';

import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../autenticacion/controladores/sesion_controlador.dart';
import 'perfil_controlador.dart';

class PerfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerfilControlador>(() => PerfilControlador(
      sesionControlador: Get.find<SesionControlador>(),
      casoUso: Get.find<DiagnosticoCasoUso>(),
    ), fenix: true);
  }
}
