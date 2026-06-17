import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../autenticacion/controladores/sesion_controlador.dart';
import 'app_rutas.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final rutasPublicas = [
      AppRutas.carga,
      AppRutas.bienvenida,
      AppRutas.login,
      AppRutas.registro,
    ];

    final rutaActual = route ?? '';

    if (rutasPublicas.contains(rutaActual)) {
      return null;
    }

    if (!SesionMemoria.sesionIniciada) {
      return const RouteSettings(
        name: AppRutas.login,
      );
    }

    return null;
  }
}