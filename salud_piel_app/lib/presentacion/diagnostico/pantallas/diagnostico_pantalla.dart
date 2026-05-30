import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';
import '../controladores/diagnostico_controlador.dart';

class DiagnosticoPantalla extends StatelessWidget {
  final DiagnosticoControlador controller;

  const DiagnosticoPantalla({
    super.key,
    required this.controller,
  });

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

            _seccionCondicion(),

            const SizedBox(height: 20),

            _seccionResultados(),

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

  Widget _seccionCondicion() {
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
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF7B5EA7)),
              SizedBox(width: 8),
              Text(
                'Sobre esta condición',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.cargandoInfoIA.value) {
              return const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Consultando con IA...',
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }

            final info = controller.informacionCondicion.value;
            if (info != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.descripcion,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      height: 1.5,
                    ),
                  ),
                  if (info.causas.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Posibles causas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...info.causas.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: Color(0xFF7B5EA7))),
                            Expanded(
                              child: Text(
                                c,
                                style: const TextStyle(
                                  color: Color(0xFF555555),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (info.recomendacionDermatologo != null &&
                      info.recomendacionDermatologo!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B5EA7).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.medical_services_outlined,
                              size: 20, color: Color(0xFF7B5EA7)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              info.recomendacionDermatologo!,
                              style: const TextStyle(
                                color: Color(0xFF444444),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (info.consejosCuidado.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Consejos de cuidado',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...info.consejosCuidado.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: Color(0xFF7B5EA7)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                c,
                                style: const TextStyle(
                                  color: Color(0xFF555555),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
            }

            return Text(
              controller.descripcion.value.isNotEmpty
                  ? controller.descripcion.value
                  : 'La ${controller.condicion.value.displayName.toLowerCase()} es una afección de la piel. Se recomienda seguir una rutina adecuada y consultar a un profesional si los síntomas persisten.',
              style: const TextStyle(
                color: Color(0xFF555555),
                height: 1.5,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _seccionResultados() {
    return Obx(() {
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
                            size: 8, color: ColoresApp.primario),
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
    });
  }
}
