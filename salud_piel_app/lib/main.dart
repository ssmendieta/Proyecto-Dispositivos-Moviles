import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'nucleo/servicios/dependencias.dart';
import 'presentacion/rutas/app_paginas.dart';
import 'presentacion/rutas/app_rutas.dart';
import 'presentacion/rutas/inicial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Dependencias.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Salud Piel',
      debugShowCheckedModeBanner: false,
      initialBinding: InicialBinding(),
      getPages: AppPaginas.paginas,
      initialRoute: AppRutas.carga,
    );
  }
}
