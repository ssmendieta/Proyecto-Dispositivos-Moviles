import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../../nucleo/servicios/ml_servicio.dart';
import '../../constantes/colores.dart';
import '../../historial/controladores/historial_controlador.dart';
import '../../historial/pantallas/historial_pantalla.dart';
import '../../inicio/controladores/inicio_controlador.dart';

class DiagnosticoPantalla extends StatelessWidget {
  const DiagnosticoPantalla({super.key});

  CondicionPiel _mapearCondicion(String condicion) {
    final texto = condicion.toLowerCase();

    if (texto.contains('acne') || texto.contains('acné')) {
      return CondicionPiel.acne;
    }
    if (texto.contains('eczema')) {
      return CondicionPiel.eczema;
    }
    if (texto.contains('rosacea') || texto.contains('rosácea')) {
      return CondicionPiel.rosacea;
    }
    if (texto.contains('melasma')) {
      return CondicionPiel.melasma;
    }
    if (texto.contains('psoriasis')) {
      return CondicionPiel.psoriasis;
    }
    if (texto.contains('dermatitis')) {
      return CondicionPiel.dermatitis;
    }
    if (texto.contains('normal') || texto.contains('sin condición')) {
      return CondicionPiel.normal;
    }

    return CondicionPiel.otro;
  }

  @override
  Widget build(BuildContext context) {
    final resultado = Get.arguments as ResultadoAnalisis?;

    final inicioControlador = Get.find<InicioControlador>();

    if (resultado == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Resultado'),
        ),
        body: const Center(
          child: Text('No hay resultado de análisis disponible.'),
        ),
      );
    }

    final porcentajeTipo =
        '${(resultado.confianzaTipoPiel * 100).toStringAsFixed(1)}%';

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Resultado del análisis',
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
                    'Tipo de piel: ${resultado.tipoPiel}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoPrincipal,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Confianza tipo de piel: $porcentajeTipo',
                    style: TextStyle(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Severidad visual: ${resultado.severidadGeneral}',
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.file(
                File(resultado.imagenPath),
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            _seccion(
              titulo: 'Condiciones detectadas',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total de detecciones: ${resultado.totalDetecciones}',
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (resultado.conteoPorCondicion.isEmpty)
                    Text(
                      'No se detectaron condiciones visibles.',
                      style: TextStyle(color: ColoresApp.textoSecundario),
                    ),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: resultado.conteoPorCondicion.entries.map((item) {
                      return Chip(
                        label: Text('${item.key}: ${item.value}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _seccion(
              titulo: 'Rutina recomendada de día',
              child: _listaTextos(resultado.rutinaDia),
            ),

            const SizedBox(height: 20),

            _seccion(
              titulo: 'Rutina recomendada de noche',
              child: _listaTextos(resultado.rutinaNoche),
            ),

            const SizedBox(height: 20),

            _seccion(
              titulo: 'Alertas y aclaraciones',
              child: _listaTextos(resultado.alertas),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  inicioControlador.cambiarPagina(3);
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Ver Productos Sugeridos'),
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

            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final historialControlador =
                      Get.find<HistorialControlador>();

                  final diagnostico = Diagnostico(
                    id: DateTime.now().millisecondsSinceEpoch,
                    imagenPath: resultado.imagenPath,
                    condicion: _mapearCondicion(resultado.condicionPrincipal),
                    confianza: resultado.confianzaCondicionPrincipal,
                    fecha: DateTime.now(),
                    descripcion:
                        'Tipo de piel: ${resultado.tipoPiel} | Severidad: ${resultado.severidadGeneral}',
                  );

                  await historialControlador.agregarAnalisis(diagnostico);

                  Get.off(
                    () => const HistorialPantalla(),
                  );
                },
                icon: const Icon(Icons.bookmark_border),
                label: const Text('Guardar en Historial'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccion({
    required String titulo,
    required Widget child,
  }) {
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
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _listaTextos(List<String> textos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textos.map((texto) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '• $texto',
            style: TextStyle(
              color: ColoresApp.textoSecundario,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}