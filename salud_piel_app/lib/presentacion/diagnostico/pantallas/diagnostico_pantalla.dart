import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';

import '../../historial/controladores/historial_controlador.dart';
import '../../historial/pantallas/historial_pantalla.dart';

import '../../inicio/controladores/inicio_controlador.dart';

class DiagnosticoPantalla extends StatelessWidget {
  const DiagnosticoPantalla({super.key});

  @override
  Widget build(BuildContext context) {

    final inicioControlador =
        Get.find<InicioControlador>();

    return Scaffold(
      backgroundColor: ColoresApp.fondo,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'SkinGPT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// RESULTADO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),

              child: Column(
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: ColoresApp.acento.withOpacity(.25),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      'ANÁLISIS COMPLETADO',
                      style: TextStyle(
                        color: ColoresApp.primario,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Dermatitis Atópica',
                    style: TextStyle(
                      color: ColoresApp.textoPrincipal,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '94% Confianza',
                    style: TextStyle(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// IMAGEN
            Container(
              height: 260,
              width: double.infinity,

              decoration: BoxDecoration(
                color: const Color(0xFF102A35),
                borderRadius: BorderRadius.circular(22),
              ),

              child: const Center(
                child: Icon(
                  Icons.image_search,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DESCRIPCIÓN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Sobre esta condición',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'La dermatitis atópica es una afección crónica de la piel que puede causar sequedad, picazón e inflamación. Se recomienda seguir una rutina hidratante y consultar a un profesional si los síntomas persisten.',

                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// PRODUCTOS
            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton.icon(
                onPressed: () {

                  Get.back();

                  inicioControlador.cambiarPagina(3);
                },

                icon: const Icon(
                  Icons.shopping_bag_outlined,
                ),

                label: const Text(
                  'Ver Productos Sugeridos',
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.primario,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// GUARDAR HISTORIAL
            SizedBox(
              width: double.infinity,
              height: 54,

              child: OutlinedButton.icon(
                onPressed: () {

                  final historialControlador =
                      Get.find<HistorialControlador>();

                  historialControlador.agregarAnalisis(
                    titulo: 'Dermatitis Atópica',
                    fecha: 'Hoy',
                    estado: 'ESTABLE',
                    porcentaje: '94%',
                  );

                  Get.off(
                    () => const HistorialPantalla(),
                  );
                },

                icon: const Icon(
                  Icons.bookmark_border,
                ),

                label: const Text(
                  'Guardar en Historial',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}