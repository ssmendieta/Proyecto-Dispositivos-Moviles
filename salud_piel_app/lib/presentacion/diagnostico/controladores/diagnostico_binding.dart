import 'package:get/get.dart';

import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../inicio/controladores/inicio_controlador.dart';
import 'diagnostico_controlador.dart';

class DiagnosticoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiagnosticoControlador>(() => DiagnosticoControlador(
      casoUso: Get.find<DiagnosticoCasoUso>(),
      inicioControlador: Get.find<InicioControlador>(),
    ), fenix: true);
  }
}
