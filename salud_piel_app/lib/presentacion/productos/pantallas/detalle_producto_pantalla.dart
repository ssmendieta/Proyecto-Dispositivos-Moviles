import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/entidades/producto.dart';
import '../../constantes/colores.dart';
import '../widget/agregar_a_rutina_sheet.dart';

class DetalleProductoPantalla extends StatelessWidget {
  final Producto producto;

  const DetalleProductoPantalla({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    final marca = producto.marca ?? 'Marca no especificada';
    final categoria = producto.categoria ?? 'Cuidado de la piel';
    final descripcion = producto.descripcion ?? 
        'Producto recomendado para apoyar una rutina personalizada de cuidado de la piel.';

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detalle del producto',
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColoresApp.fondo,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(
                      Icons.spa_outlined,
                      size: 90,
                      color: ColoresApp.primario,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    producto.nombre,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    marca,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      fontSize: 16,
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
                      categoria,
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

            _seccion(
              titulo: 'Descripción',
              icono: Icons.info_outline,
              contenido: descripcion,
            ),

            const SizedBox(height: 16),

            _seccion(
              titulo: 'Beneficios principales',
              icono: Icons.check_circle_outline,
              contenido:
                  '• Ayuda a mantener la piel cuidada.\n'
                  '• Complementa la rutina diaria.\n'
                  '• Recomendado según el tipo de piel y diagnóstico.',
            ),

            const SizedBox(height: 16),

            _seccion(
              titulo: 'Modo de uso',
              icono: Icons.schedule_outlined,
              contenido:
                  'Aplicar según la indicación de la rutina. Evitar contacto con los ojos y suspender su uso si aparece irritación.',
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.bottomSheet(
                    AgregarARutinaSheet(producto: producto),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar a rutina'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.primario,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
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
          Icon(icono, color: ColoresApp.primario),
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