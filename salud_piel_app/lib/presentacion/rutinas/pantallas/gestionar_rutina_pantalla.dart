import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../controladores/rutinas_controlador.dart';

class GestionarRutinaPantalla extends StatelessWidget {
  const GestionarRutinaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = Get.find<RutinasControlador>();

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Rutina de Mañana',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              controlador.rutinaManana.clear();
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Eliminar Todo'),
            style: TextButton.styleFrom(
              foregroundColor: ColoresApp.peligro,
            ),
          ),
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'ORDEN DE APLICACIÓN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoSecundario,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${controlador.rutinaManana.length} Productos',
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child: controlador.rutinaManana.isEmpty
                    ? Center(
                        child: Text(
                          'No tienes productos en esta rutina.',
                          style: TextStyle(
                            color: ColoresApp.textoSecundario,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controlador.rutinaManana.length,
                        itemBuilder: (context, index) {
                          final producto = controlador.rutinaManana[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.drag_indicator,
                                  color: ColoresApp.textoSecundario,
                                ),

                                const SizedBox(width: 10),

                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: ColoresApp.fondo,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.spa_outlined),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PASO ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: ColoresApp.primario,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        producto['nombre'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColoresApp.textoPrincipal,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        producto['marca'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ColoresApp.textoSecundario,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    controlador.rutinaManana.removeAt(index);
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.back();
                    final inicio = Get.find<dynamic>();
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Añadir Producto a la Rutina'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}