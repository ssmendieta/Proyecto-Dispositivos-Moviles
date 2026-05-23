import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'nucleo/servicios/dependencias.dart';
import 'presentacion/rutas/app_routes.dart';

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
      getPages: AppRoutes.paginas,
      initialRoute: AppRoutes.splash,
    );
  }
}
