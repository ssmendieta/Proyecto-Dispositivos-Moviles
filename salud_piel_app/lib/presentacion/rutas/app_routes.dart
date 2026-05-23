import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String bienvenida = '/bienvenida';
  static const String login = '/login';
  static const String registro = '/registro';
  static const String inicio = '/inicio';
  static const String escaneo = '/escaneo';
  static const String diagnostico = '/diagnostico';
  static const String productos = '/productos';
  static const String productoDetalle = '/productos/detalle';
  static const String rutinas = '/rutinas';
  static const String gestionarRutina = '/rutinas/gestionar';
  static const String perfil = '/perfil';
  static const String historial = '/historial';
  static const String escaneoDetalle = '/historial/detalle';

  static final List<GetPage> paginas = [
    GetPage(name: splash, page: () => const _Placeholder(nombre: 'Splash')),
    GetPage(name: bienvenida, page: () => const _Placeholder(nombre: 'Bienvenida')),
    GetPage(name: login, page: () => const _Placeholder(nombre: 'Login')),
    GetPage(name: registro, page: () => const _Placeholder(nombre: 'Registro')),
    GetPage(name: inicio, page: () => const _Placeholder(nombre: 'Inicio')),
    GetPage(name: escaneo, page: () => const _Placeholder(nombre: 'Escaneo')),
    GetPage(name: diagnostico, page: () => const _Placeholder(nombre: 'Diagnóstico')),
    GetPage(name: productos, page: () => const _Placeholder(nombre: 'Productos')),
    GetPage(name: productoDetalle, page: () => const _Placeholder(nombre: 'Producto Detalle')),
    GetPage(name: rutinas, page: () => const _Placeholder(nombre: 'Rutinas')),
    GetPage(name: gestionarRutina, page: () => const _Placeholder(nombre: 'Gestionar Rutina')),
    GetPage(name: perfil, page: () => const _Placeholder(nombre: 'Perfil')),
    GetPage(name: historial, page: () => const _Placeholder(nombre: 'Historial')),
    GetPage(name: escaneoDetalle, page: () => const _Placeholder(nombre: 'Escaneo Detalle')),
  ];
}

class _Placeholder extends StatelessWidget {
  final String nombre;
  const _Placeholder({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: Center(
        child: Text(
          'Pantalla: $nombre',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
