import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/inicio_provider.dart';
import '../../compartidos/widget/barra_inferior.dart';

import 'home_pantalla.dart';
import '../../rutinas/pantallas/rutinas_pantalla.dart';
import '../../escaneo/pantallas/escaneo_pantalla.dart';
import '../../productos/pantallas/productos_pantalla.dart';
import '../../perfil/pantallas/perfil_pantalla.dart';

class InicioPantalla extends ConsumerWidget {
  const InicioPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indiceActual = ref.watch(indiceActualProvider);

    final paginas = [
      const HomePantalla(),
      const RutinasPantalla(),
      const EscaneoPantalla(),
      ProductosPantalla(),
      const PerfilPantalla(),
    ];

    return Scaffold(
      body: paginas[indiceActual],
      bottomNavigationBar: BarraInferior(
        indiceActual: indiceActual,
        alCambiar: (nuevoIndice) {
          ref.read(indiceActualProvider.notifier).state = nuevoIndice;
        },
      ),
    );
  }
}