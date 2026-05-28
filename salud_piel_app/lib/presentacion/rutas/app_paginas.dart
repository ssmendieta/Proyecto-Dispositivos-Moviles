import 'package:get/get.dart';

import '../autenticacion/controladores/login_binding.dart';
import '../autenticacion/controladores/registro_binding.dart';
import '../autenticacion/pantallas/login_pantalla.dart';
import '../autenticacion/pantallas/registro_pantalla.dart';

import '../bienvenida/controladores/bienvenida_binding.dart';
import '../bienvenida/pantallas/bienvenida_pantalla.dart';

import '../carga/controladores/carga_binding.dart';
import '../carga/pantallas/carga_pantalla.dart';

import '../diagnostico/controladores/diagnostico_binding.dart';
import '../diagnostico/pantallas/diagnostico_pantalla.dart';
import '../escaneo/pantallas/escaneo_pantalla.dart';

import '../historial/controladores/historial_binding.dart';
import '../historial/pantallas/historial_pantalla.dart';

import '../inicio/controladores/inicio_binding.dart';
import '../inicio/pantallas/inicio_pantalla.dart';

import '../perfil/pantallas/perfil_pantalla.dart';

import '../productos/pantallas/productos_pantalla.dart';

import '../rutinas/controladores/rutinas_binding.dart';
import '../rutinas/pantallas/gestionar_rutina_pantalla.dart';
import '../rutinas/pantallas/rutinas_pantalla.dart';

import 'app_rutas.dart';

class AppPaginas {

  static final paginas = [

    /// CARGA
    GetPage(
      name: AppRutas.carga,
      page: () => const CargaPantalla(),
      binding: CargaBinding(),
    ),

    /// BIENVENIDA
    GetPage(
      name: AppRutas.bienvenida,
      page: () => const BienvenidaPantalla(),
      binding: BienvenidaBinding(),
    ),

    /// LOGIN
    GetPage(
      name: AppRutas.login,
      page: () => LoginPantalla(),
      binding: LoginBinding(),
    ),

    /// REGISTRO
    GetPage(
      name: AppRutas.registro,
      page: () => RegistroPantalla(),
      binding: RegistroBinding(),
    ),

    /// INICIO (HOME CON BOTTOM NAV)
    GetPage(
      name: AppRutas.inicio,
      page: () => const InicioPantalla(),
      binding: InicioBinding(),
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
      binding: DiagnosticoBinding(),
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
      binding: RutinasBinding(),
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
      binding: HistorialBinding(),
    ),
  ];
}
