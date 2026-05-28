import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../../dominio/entidades/rutina.dart';
import '../../inicio/controladores/inicio_controlador.dart';
import '../controladores/rutinas_controlador.dart';

class GestionarRutinaPantalla extends GetView<RutinasControlador> {
  const GestionarRutinaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Gestionar Rutina',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(
        () {
          controller.rutinas.length;
          return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  labelColor: ColoresApp.primario,
                  unselectedLabelColor: ColoresApp.textoSecundario,
                  indicatorColor: ColoresApp.primario,
                  tabs: const [
                    Tab(text: 'Mañana'),
                    Tab(text: 'Noche'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _listaGestion(
                      titulo: 'Rutina de Mañana',
                      productos: controller.rutinaManana,
                      onReorder: controller.reordenarManana,
                      onEliminar: controller.eliminarManana,
                      onAgregar: () {
                        Get.back();
                        Get.find<InicioControlador>().cambiarPagina(3);
                      },
                    ),
                    _listaGestion(
                      titulo: 'Rutina de Noche',
                      productos: controller.rutinaNoche,
                      onReorder: controller.reordenarNoche,
                      onEliminar: controller.eliminarNoche,
                      onAgregar: () {
                        Get.back();
                        Get.find<InicioControlador>().cambiarPagina(3);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        },
      ),
    );
  }

  Widget _listaGestion({
    required String titulo,
    required List<RutinaProducto> productos,
    required Future<void> Function(int oldIndex, int newIndex) onReorder,
    required Future<void> Function(int index) onEliminar,
    required VoidCallback onAgregar,
  }) {
    return Padding(
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
                '${productos.length} Productos',
                style: TextStyle(
                  color: ColoresApp.textoSecundario,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: productos.isEmpty
                ? Center(
                    child: Text(
                      'No tienes productos en esta rutina.',
                      style: TextStyle(
                        color: ColoresApp.textoSecundario,
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    itemCount: productos.length,
                    onReorder: (oldIndex, newIndex) {
                      onReorder(oldIndex, newIndex);
                    },
                    buildDefaultDragHandles: false,
                    itemBuilder: (context, index) {
                      final rp = productos[index];

                      return Container(
                        key: ValueKey('${rp.producto.id}-$index'),
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            ReorderableDragStartListener(
                              index: index,
                              child: Icon(
                                Icons.drag_indicator,
                                color: ColoresApp.textoSecundario,
                              ),
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
                                    rp.producto.nombre,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColoresApp.textoPrincipal,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    rp.producto.marca ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColoresApp.textoSecundario,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => onEliminar(index),
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
              onPressed: onAgregar,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Añadir Producto a la Rutina'),
            ),
          ),
        ],
      ),
    );
  }
}
