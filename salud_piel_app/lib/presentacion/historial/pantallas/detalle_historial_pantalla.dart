import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../constantes/colores.dart';

class DetalleHistorialPantalla extends StatelessWidget {
  final Diagnostico diagnostico;

  const DetalleHistorialPantalla({
    super.key,
    required this.diagnostico,
  });

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd MMM yyyy - HH:mm').format(diagnostico.fecha);
    final confianza = (diagnostico.confianza * 100).round();
    final imagenPath = diagnostico.imagenPath;
    final descripcion = diagnostico.descripcion ?? '';

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detalle del análisis',
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
                  Text(
                    diagnostico.condicion.displayName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    fecha,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColoresApp.acento.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$confianza% de confianza',
                      style: TextStyle(
                        color: ColoresApp.primario,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF102A35),
                borderRadius: BorderRadius.circular(22),
              ),
              child: imagenPath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.file(
                        File(imagenPath),
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
            ),

            const SizedBox(height: 20),

            _seccion(
              titulo: 'Descripción del diagnóstico',
              icono: Icons.info_outline,
              contenido: descripcion.isNotEmpty
                  ? descripcion
                  : 'No se registró una descripción detallada para este análisis.',
            ),

            const SizedBox(height: 16),

            _seccion(
              titulo: 'Contexto generado por IA',
              icono: Icons.smart_toy_outlined,
              contenido:
                  'Aquí se mostrará el contexto ampliado del análisis cuando el modelo de IA esté conectado. Incluirá recomendaciones, posibles causas y observaciones importantes.',
            ),

            const SizedBox(height: 16),

            _seccion(
              titulo: 'Recomendación inicial',
              icono: Icons.medical_services_outlined,
              contenido:
                  'Mantén una rutina de cuidado adecuada y consulta con un profesional de salud si observas irritación, dolor, cambios rápidos o síntomas persistentes.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccion({
    required String titulo,
    required IconData icono,
    required String contenido,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icono,
            color: ColoresApp.primario,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  contenido,
                  style: TextStyle(
                    color: ColoresApp.textoSecundario,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}