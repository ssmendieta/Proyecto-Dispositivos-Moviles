import 'package:get/get.dart';

import '../autenticacion/pantallas/login_pantalla.dart';
import '../autenticacion/pantallas/registro_pantalla.dart';
import '../bienvenida/pantallas/bienvenida_pantalla.dart';
import '../carga/pantallas/carga_pantalla.dart';
import '../diagnostico/pantallas/diagnostico_pantalla.dart';
import '../escaneo/pantallas/escaneo_pantalla.dart';
import '../historial/pantallas/historial_pantalla.dart';
import '../inicio/pantallas/inicio_pantalla.dart';
import '../perfil/pantallas/perfil_pantalla.dart';
import '../productos/pantallas/productos_pantalla.dart';
import '../rutinas/pantallas/gestionar_rutina_pantalla.dart';
import '../rutinas/pantallas/rutinas_pantalla.dart';
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

    /// INICIO (HOME CON BOTTOM NAV)
    GetPage(
      name: AppRutas.inicio,
      page: () => const InicioPantalla(),
    ),

    /// ESCANEO
    GetPage(
      name: AppRutas.escaneo,
      page: () => const EscaneoPantalla(),
    ),

    /// DIAGNOSTICO
    GetPage(
      name: AppRutas.diagnostico,
      page: () => const DiagnosticoPantalla(),
    ),

    /// PRODUCTOS
    GetPage(
      name: AppRutas.productos,
      page: () => ProductosPantalla(),
    ),

    /// RUTINAS
    GetPage(
      name: AppRutas.rutinas,
      page: () => const RutinasPantalla(),
    ),

    /// GESTIONAR RUTINA
    GetPage(
      name: AppRutas.gestionarRutina,
      page: () => const GestionarRutinaPantalla(),
    ),

    /// PERFIL
    GetPage(
      name: AppRutas.perfil,
      page: () => const PerfilPantalla(),
    ),

    /// HISTORIAL
    GetPage(
      name: AppRutas.historial,
      page: () => const HistorialPantalla(),
    ),
  ];
}
