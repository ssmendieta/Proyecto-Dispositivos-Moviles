import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../rutinas/controladores/rutinas_controlador.dart';
import '../controladores/inicio_controlador.dart';
import '../widgets/tarjeta_producto_grande.dart';
import '../widgets/tarjeta_producto_pequena.dart';
import '../widgets/tarjeta_producto_grande.dart';
import '../../rutas/app_rutas.dart';

class HomePantalla extends GetView<InicioControlador> {
  const HomePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final rutinasControlador = Get.find<RutinasControlador>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE6D5F7),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SkinGPT',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.textoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Estado de la piel',
                      style: TextStyle(
                        fontSize: 15,
                        color: ColoresApp.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ESTADO DE LA PIEL',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoSecundario,
                      letterSpacing: 1,
                    ),
                  ),
                 TextButton(
                    onPressed: controller.irAHistorial,
                    child: const Text('Ver historial'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                controller.cambiarPagina(2);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColoresApp.primario,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.center_focus_strong,
                      color: Colors.white,
                      size: 46,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Iniciar Nuevo Análisis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Escanea tu piel usando inteligencia artificial dermatológica',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tu Rutina Diaria',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.cambiarPagina(1);
                  },
                  child: const Text('Ver todo'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Obx(() {
              rutinasControlador.rutinas.length;
              final manana = rutinasControlador.rutinaManana;
              if (manana.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        color: ColoresApp.primario,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'RUTINA DE MAÑANA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: ColoresApp.primario,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: manana.take(2).map((rp) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: TarjetaProductoPequena(
                          nombre: rp.producto.nombre,
                          marca: rp.producto.marca ?? '',
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 28),
                ],
              );
            }),

            Obx(() {
              rutinasControlador.rutinas.length;
              final noche = rutinasControlador.rutinaNoche;
              if (noche.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.nightlight_round,
                        color: ColoresApp.primario,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'RUTINA DE NOCHE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: ColoresApp.primario,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TarjetaProductoGrande(
                    nombre: noche.first.producto.nombre,
                    marca: noche.first.producto.marca ?? '',
                  ),
                  const SizedBox(height: 28),
                ],
              );
            }),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColoresApp.acento.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: ColoresApp.acento,
                    size: 34,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Mantenerse hidratado es fundamental para la elasticidad de la piel. Beber agua ayudará a reducir líneas de expresión finas.',
                      style: TextStyle(
                        color: ColoresApp.textoPrincipal,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
