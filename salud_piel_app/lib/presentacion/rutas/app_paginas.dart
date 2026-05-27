import 'package:get/get.dart';

import '../autenticacion/pantallas/login_pantalla.dart';
import '../autenticacion/pantallas/registro_pantalla.dart';

import '../bienvenida/pantallas/bienvenida_pantalla.dart';

import '../carga/pantallas/carga_pantalla.dart';

import '../diagnostico/pantallas/diagnostico_pantalla.dart';

import '../historial/controladores/historial_controlador.dart';
import '../historial/pantallas/historial_pantalla.dart';

import '../inicio/controladores/inicio_controlador.dart';
import '../inicio/pantallas/inicio_pantalla.dart';

import '../productos/controladores/productos_controlador.dart';

import '../rutinas/controladores/rutinas_controlador.dart';

import 'app_rutas.dart';

class AppPaginas {

  static final paginas = [

    /// CARGA
    GetPage(
      name: AppRutas.carga,
      page: () => const CargaPantalla(),
    ),

    /// BIENVENIDA
    GetPage(
      name: AppRutas.bienvenida,
      page: () => const BienvenidaPantalla(),
    ),

    /// LOGIN
    GetPage(
      name: AppRutas.login,
      page: () => LoginPantalla(),
    ),

    /// REGISTRO
    GetPage(
      name: AppRutas.registro,
      page: () => RegistroPantalla(),
    ),

    /// HOME
    GetPage(
      name: AppRutas.inicio,

      page: () => const InicioPantalla(),

      binding: BindingsBuilder(() {

        Get.put<InicioControlador>(
          InicioControlador(),
          permanent: true,
        );

        Get.put<ProductosControlador>(
          ProductosControlador(),
          permanent: true,
        );

        Get.put<HistorialControlador>(
          HistorialControlador(),
          permanent: true,
        );

        Get.put<RutinasControlador>(
          RutinasControlador(),
          permanent: true,
        );

      }),
    ),

    /// DIAGNOSTICO
    GetPage(
      name: AppRutas.diagnostico,
      page: () => const DiagnosticoPantalla(),
    ),

    /// HISTORIAL
    GetPage(
      name: AppRutas.historial,
      page: () => const HistorialPantalla(),
    ),
  ];
}