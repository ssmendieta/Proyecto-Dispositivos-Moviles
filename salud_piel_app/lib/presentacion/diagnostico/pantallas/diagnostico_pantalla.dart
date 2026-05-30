import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';
import '../controladores/diagnostico_controlador.dart';

class DiagnosticoPantalla extends GetView<DiagnosticoControlador> {
  const DiagnosticoPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'SkinGPT',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                      color: ColoresApp.acento.withValues(alpha: 0.25),
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

                  Obx(
                    () => Text(
                      controller.condicion.value.displayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColoresApp.textoPrincipal,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Obx(
                    () => Text(
                      '${(controller.confianza.value * 100).round()}% Confianza',
                      style: TextStyle(
                        color: ColoresApp.primario,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Obx(() {
              final path = controller.imagenPath.value;

              return Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF102A35),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: path.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.file(
                          File(path),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 80,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.image_search,
                        color: Colors.white,
                        size: 80,
                      ),
              );
            }),

            const SizedBox(height: 20),

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

                  Obx(
                    () => Text(
                      controller.descripcion.value.isNotEmpty
                          ? controller.descripcion.value
                          : 'La ${controller.condicion.value.displayName.toLowerCase()} es una afección de la piel. Se recomienda seguir una rutina adecuada y consultar a un profesional si los síntomas persisten.',
                      style: TextStyle(
                        color: ColoresApp.textoSecundario,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Obx(() {
              final detecciones = controller.deteccionesResumen;
              final severidadText = controller.severidad.value;

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.smart_toy_outlined,
                          color: ColoresApp.primario,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Resultados del análisis',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (severidadText.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 18, color: ColoresApp.primario),
                          const SizedBox(width: 8),
                          Text(
                            'Severidad: ${severidadText.toUpperCase()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ColoresApp.textoPrincipal,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (detecciones.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      ...detecciones.entries.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 8,
                                    color: ColoresApp.primario),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${e.key}: ${e.value}',
                                    style: TextStyle(
                                      color: ColoresApp.textoSecundario,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],

                    const SizedBox(height: 14),

                    Text(
                      controller.descripcion.value.isNotEmpty
                          ? controller.descripcion.value
                          : 'Análisis completado. No se detectaron condiciones significativas.',
                      style: TextStyle(
                        color: ColoresApp.textoSecundario,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 12),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: controller.guardando.value
                      ? null
                      : () async {
                          await controller.guardarEnHistorial();
                          Get.offNamed(AppRutas.historial);
                        },
                  icon: Icon(
                    controller.guardando.value
                        ? Icons.hourglass_top
                        : Icons.bookmark_border,
                  ),
                  label: Text(
                    controller.guardando.value
                        ? 'Guardando...'
                        : 'Guardar en historial',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}