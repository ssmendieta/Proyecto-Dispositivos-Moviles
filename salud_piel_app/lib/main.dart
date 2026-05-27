import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'presentacion/constantes/colores.dart';
import 'presentacion/rutas/app_paginas.dart';
import 'presentacion/rutas/app_rutas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',

      initialRoute: AppRutas.carga,
      getPages: AppPaginas.paginas,

      theme: ThemeData(
        scaffoldBackgroundColor: ColoresApp.fondo,
        useMaterial3: true,
      ),
    );
  }
}