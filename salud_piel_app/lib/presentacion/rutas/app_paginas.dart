import 'package:get/get.dart';

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

    GetPage(
      name: AppRutas.diagnostico,
      page: () => const DiagnosticoPantalla(),
    ),

    GetPage(
      name: AppRutas.historial,
      page: () => const HistorialPantalla(),
    ),
  ];
}