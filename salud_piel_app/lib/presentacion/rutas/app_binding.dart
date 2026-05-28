import 'package:get/get.dart';

import '../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../dominio/casos_uso/producto_caso_uso.dart';
import '../../dominio/casos_uso/rutina_caso_uso.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';
import '../../dominio/repositorios/i_diagnostico_repositorio.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../../dominio/repositorios/i_rutina_repositorio.dart';
import '../autenticacion/controladores/login_controlador.dart';
import '../autenticacion/controladores/registro_controlador.dart';
import '../autenticacion/controladores/sesion_controlador.dart';
import '../bienvenida/controladores/bienvenida_controlador.dart';
import '../carga/controladores/carga_controlador.dart';
import '../diagnostico/controladores/diagnostico_controlador.dart';
import '../escaneo/controladores/escaneo_controlador.dart';
import '../historial/controladores/historial_controlador.dart';
import '../inicio/controladores/inicio_controlador.dart';
import '../perfil/controladores/perfil_controlador.dart';
import '../productos/controladores/productos_controlador.dart';
import '../rutinas/controladores/rutinas_controlador.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AutenticacionCasoUso>(AutenticacionCasoUso(
      repositorio: Get.find<IAuthRepositorio>(),
    ));

    Get.put<DiagnosticoCasoUso>(DiagnosticoCasoUso(
      repositorio: Get.find<IDiagnosticoRepositorio>(),
    ));

    Get.put<RutinaCasoUso>(RutinaCasoUso(
      repositorio: Get.find<IRutinaRepositorio>(),
    ));

    Get.put<ProductoCasoUso>(ProductoCasoUso(
      repositorio: Get.find<IProductoRepositorio>(),
    ));

    Get.put<SesionControlador>(SesionControlador(
      casoUso: Get.find<AutenticacionCasoUso>(),
    ));

    Get.put<InicioControlador>(InicioControlador());
    Get.put<CargaControlador>(CargaControlador(
      casoUso: Get.find<AutenticacionCasoUso>(),
    ));
    Get.put<BienvenidaControlador>(BienvenidaControlador());
    Get.put<LoginControlador>(LoginControlador(
      casoUso: Get.find<AutenticacionCasoUso>(),
    ));
    Get.put<RegistroControlador>(RegistroControlador(
      casoUso: Get.find<AutenticacionCasoUso>(),
    ));
    Get.put<EscaneoControlador>(EscaneoControlador());
    Get.put<DiagnosticoControlador>(DiagnosticoControlador(
      casoUso: Get.find<DiagnosticoCasoUso>(),
    ));
    Get.put<ProductosControlador>(ProductosControlador(
      casoUso: Get.find<ProductoCasoUso>(),
    ));
    Get.put<RutinasControlador>(RutinasControlador(
      casoUso: Get.find<RutinaCasoUso>(),
    ));
    Get.put<PerfilControlador>(PerfilControlador(
      casoUso: Get.find<DiagnosticoCasoUso>(),
    ));
    Get.put<HistorialControlador>(HistorialControlador(
      casoUso: Get.find<DiagnosticoCasoUso>(),
    ));
  }
}
