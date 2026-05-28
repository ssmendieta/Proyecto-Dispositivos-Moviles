import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../controladores/historial_controlador.dart';
import '../widget/tarjeta_historial.dart';

class HistorialPantalla extends GetView<HistorialControlador> {
  const HistorialPantalla({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Historial de Análisis',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.textoPrincipal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Todos',
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Expanded(
                  child: controller.cargando.value
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: controller.analisis.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.analisis.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16, bottom: 30),
                                child: Center(
                                  child: SizedBox(
                                    width: 240,
                                    height: 52,
                                    child: OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      label: const Text('Cargar más análisis'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: ColoresApp.primario,
                                        side: BorderSide(
                                          color: ColoresApp.primario,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final item = controller.analisis[index];

                            return TarjetaHistorial(
                              diagnostico: item,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
