import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controladores/inicio_controlador.dart';
import '../../compartidos/widget/barra_inferior.dart';

import 'home_pantalla.dart';
import '../../rutinas/pantallas/rutinas_pantalla.dart';
import '../../escaneo/pantallas/escaneo_pantalla.dart';
import '../../productos/pantallas/productos_pantalla.dart';
import '../../perfil/pantallas/perfil_pantalla.dart';

class InicioPantalla extends GetView<InicioControlador> {
  const InicioPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final paginas = [
      const HomePantalla(),
      const RutinasPantalla(),
      const EscaneoPantalla(),
      ProductosPantalla(),
      const PerfilPantalla(),
    ];

    return Obx(
      () => Scaffold(
        body: paginas[controller.indiceActual.value],
        bottomNavigationBar: BarraInferior(
          indiceActual: controller.indiceActual.value,
          alCambiar: controller.cambiarPagina,
        ),
      ),
    );
  }
}