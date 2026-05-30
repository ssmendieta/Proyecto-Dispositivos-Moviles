import 'package:get/get.dart';

import '../../dominio/entidades/diagnostico.dart';
import '../../dominio/entidades/producto.dart';
import '../autenticacion/pantallas/login_pantalla.dart';
import '../autenticacion/pantallas/registro_pantalla.dart';
import '../bienvenida/pantallas/bienvenida_pantalla.dart';
import '../carga/pantallas/carga_pantalla.dart';
import '../diagnostico/pantallas/diagnostico_pantalla.dart';
import '../escaneo/pantallas/escaneo_pantalla.dart';
import '../historial/pantallas/detalle_historial_pantalla.dart';
import '../historial/pantallas/historial_pantalla.dart';
import '../informacion_personal/pantallas/informacion_personal_pantalla.dart';
import '../inicio/pantallas/inicio_pantalla.dart';
import '../perfil/pantallas/perfil_pantalla.dart';
import '../productos/pantallas/detalle_producto_pantalla.dart';
import '../productos/pantallas/productos_pantalla.dart';
import '../rutinas/pantallas/gestionar_rutina_pantalla.dart';
import '../rutinas/pantallas/rutinas_pantalla.dart';
import 'app_rutas.dart';

class AppPaginas {
  static final paginas = [
    GetPage(
      name: AppRutas.carga,
      page: () => const CargaPantalla(),
    ),
    GetPage(
      name: AppRutas.bienvenida,
      page: () => const BienvenidaPantalla(),
    ),
    GetPage(
      name: AppRutas.login,
      page: () => const LoginPantalla(),
    ),
    GetPage(
      name: AppRutas.registro,
      page: () => const RegistroPantalla(),
    ),
    GetPage(
      name: AppRutas.informacionPersonal,
      page: () => const InformacionPersonalPantalla(),
    ),
    GetPage(
      name: AppRutas.inicio,
      page: () => const InicioPantalla(),
    ),
    GetPage(
      name: AppRutas.escaneo,
      page: () => const EscaneoPantalla(),
    ),
    GetPage(
      name: AppRutas.diagnostico,
      page: () => const DiagnosticoPantalla(),
    ),
    GetPage(
      name: AppRutas.productos,
      page: () => ProductosPantalla(),
    ),
    GetPage(
      name: AppRutas.productoDetalle,
      page: () {
        final producto = Get.arguments as Producto;
        return DetalleProductoPantalla(producto: producto);
      },
    ),
    GetPage(
      name: AppRutas.rutinas,
      page: () => const RutinasPantalla(),
    ),
    GetPage(
      name: AppRutas.gestionarRutina,
      page: () => const GestionarRutinaPantalla(),
    ),
    GetPage(
      name: AppRutas.perfil,
      page: () => const PerfilPantalla(),
    ),
    GetPage(
      name: AppRutas.historial,
      page: () => const HistorialPantalla(),
    ),
    GetPage(
      name: AppRutas.historialDetalle,
      page: () {
        final diagnostico = Get.arguments as Diagnostico;
        return DetalleHistorialPantalla(diagnostico: diagnostico);
      },
    ),
  ];
}
