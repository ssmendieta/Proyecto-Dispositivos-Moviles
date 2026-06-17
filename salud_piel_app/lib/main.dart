import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'datos/dependencias.dart';
import 'datos/providers/dependencias_provider.dart';
import 'presentacion/rutas/app_binding.dart';
import 'presentacion/rutas/app_paginas.dart';
import 'presentacion/rutas/app_rutas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/.env');

  final dependencias = await Dependencias.init();

  runApp(
    ProviderScope(
      overrides: [
        appDependenciasProvider.overrideWithValue(dependencias),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Salud Piel',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      getPages: AppPaginas.paginas,
      initialRoute: AppRutas.carga,
    );
  }
}