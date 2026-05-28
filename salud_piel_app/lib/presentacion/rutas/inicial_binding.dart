import 'package:get/get.dart';

import '../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../dominio/casos_uso/producto_caso_uso.dart';
import '../../dominio/casos_uso/rutina_caso_uso.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';
import '../../dominio/repositorios/i_diagnostico_repositorio.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../../dominio/repositorios/i_rutina_repositorio.dart';
import '../autenticacion/controladores/sesion_controlador.dart';
import '../escaneo/controladores/escaneo_controlador.dart';
import '../historial/controladores/historial_controlador.dart';
import '../inicio/controladores/inicio_controlador.dart';
import '../perfil/controladores/perfil_controlador.dart';
import '../productos/controladores/productos_controlador.dart';
import '../rutinas/controladores/rutinas_controlador.dart';

class InicialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InicioControlador>(() => InicioControlador(), fenix: true);

    Get.put<AutenticacionCasoUso>(AutenticacionCasoUso(
          repositorio: Get.find<IAuthRepositorio>(),
        ));

    Get.lazyPut<DiagnosticoCasoUso>(() => DiagnosticoCasoUso(
          repositorio: Get.find<IDiagnosticoRepositorio>(),
        ), fenix: true);

    Get.lazyPut<RutinaCasoUso>(() => RutinaCasoUso(
          repositorio: Get.find<IRutinaRepositorio>(),
        ), fenix: true);

    Get.lazyPut<ProductoCasoUso>(() => ProductoCasoUso(
          repositorio: Get.find<IProductoRepositorio>(),
        ), fenix: true);

    Get.put<SesionControlador>(SesionControlador(
          casoUso: Get.find<AutenticacionCasoUso>(),
        ));

    Get.lazyPut<HistorialControlador>(() => HistorialControlador(
          casoUso: Get.find<DiagnosticoCasoUso>(),
        ), fenix: true);

    Get.lazyPut<RutinasControlador>(() => RutinasControlador(
          casoUso: Get.find<RutinaCasoUso>(),
          inicioControlador: Get.find<InicioControlador>(),
        ), fenix: true);

    Get.lazyPut<ProductosControlador>(() => ProductosControlador(
          casoUso: Get.find<ProductoCasoUso>(),
        ), fenix: true);

    Get.lazyPut<EscaneoControlador>(() => EscaneoControlador(
          inicioControlador: Get.find<InicioControlador>(),
        ), fenix: true);

    Get.lazyPut<PerfilControlador>(() => PerfilControlador(
          sesionControlador: Get.find<SesionControlador>(),
          casoUso: Get.find<DiagnosticoCasoUso>(),
        ), fenix: true);
  }
}
