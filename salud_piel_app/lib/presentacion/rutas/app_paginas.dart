import 'package:flutter/material.dart';

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
import 'auth_middleware.dart';

class AppPaginas {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final redireccion = AuthMiddleware.redirect(settings.name);

    if (redireccion != null) {
      return _crearRuta(
        RouteSettings(
          name: redireccion.name,
          arguments: redireccion.arguments,
        ),
        _paginaPorRuta(
          RouteSettings(
            name: redireccion.name,
            arguments: redireccion.arguments,
          ),
        ),
      );
    }

    return _crearRuta(
      settings,
      _paginaPorRuta(settings),
    );
  }

  static MaterialPageRoute<dynamic> _crearRuta(
    RouteSettings settings,
    Widget pagina,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => pagina,
    );
  }

  static Widget _paginaPorRuta(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case AppRutas.carga:
        return const CargaPantalla();

      case AppRutas.bienvenida:
        return const BienvenidaPantalla();

      case AppRutas.login:
        return const LoginPantalla();

      case AppRutas.registro:
        return const RegistroPantalla();

      case AppRutas.informacionPersonal:
        return const InformacionPersonalPantalla();

      case AppRutas.inicio:
        return const InicioPantalla();

      case AppRutas.escaneo:
        return const EscaneoPantalla();

      case AppRutas.diagnostico:
        return const DiagnosticoPantalla();

      case AppRutas.productos:
        return const ProductosPantalla();

      case AppRutas.productoDetalle:
        final argumento = settings.arguments;

        if (argumento is Producto) {
          return DetalleProductoPantalla(
            producto: argumento,
          );
        }

        return const ProductosPantalla();

      case AppRutas.rutinas:
        return const RutinasPantalla();

      case AppRutas.gestionarRutina:
        return const GestionarRutinaPantalla();

      case AppRutas.perfil:
        return const PerfilPantalla();

      case AppRutas.historial:
        return const HistorialPantalla();

      case AppRutas.historialDetalle:
        final argumento = settings.arguments;

        if (argumento is Diagnostico) {
          return DetalleHistorialPantalla(
            diagnostico: argumento,
          );
        }

        return const HistorialPantalla();

      default:
        return const CargaPantalla();
    }
  }
}