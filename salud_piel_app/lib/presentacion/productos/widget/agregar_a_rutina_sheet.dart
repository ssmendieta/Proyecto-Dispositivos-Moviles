import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/entidades/producto.dart';
import '../../constantes/colores.dart';
import '../../rutinas/controladores/rutinas_controlador.dart';

class AgregarARutinaSheet extends StatelessWidget {
  final Producto producto;

  const AgregarARutinaSheet({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    final controlador = Get.find<RutinasControlador>();
    controlador.resetSheetState();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Añadir a mi rutina',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColoresApp.textoPrincipal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              producto.nombre,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColoresApp.textoSecundario,
              ),
            ),
            const SizedBox(height: 24),
            _opcionRutina(
              icono: Icons.wb_sunny_outlined,
              titulo: 'Rutina de Mañana',
              descripcion: 'Ideal para limpieza, hidratación y protección solar',
              seleccionado: controlador.mananaSeleccionada.value,
              onTap: controlador.toggleMananaSheet,
            ),
            const SizedBox(height: 12),
            _opcionRutina(
              icono: Icons.nightlight_round,
              titulo: 'Rutina de Noche',
              descripcion: 'Ideal para reparación, tratamiento y nutrición',
              seleccionado: controlador.nocheSeleccionada.value,
              onTap: controlador.toggleNocheSheet,
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  Get.back();

                  if (!controlador.mananaSeleccionada.value &&
    !controlador.nocheSeleccionada.value) {

                  Get.snackbar(
                    'Selecciona una rutina',
                    'Debes elegir mañana o noche',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );

                  return;
                }
                  await controlador.agregarProducto(
                    producto: producto,
                    manana: controlador.mananaSeleccionada.value,
                    noche: controlador.nocheSeleccionada.value,
                  );

                  Get.snackbar(
                    'Producto añadido',
                    '${producto.nombre} fue añadido correctamente',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 12,
                    duration: const Duration(seconds: 2),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.primario,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Confirmar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcionRutina({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: seleccionado
              ? ColoresApp.acento.withValues(alpha: 0.18)
              : ColoresApp.fondo,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seleccionado ? ColoresApp.acento : ColoresApp.borde,
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icono,
              color: seleccionado ? ColoresApp.acento : ColoresApp.primario,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: 12,
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: seleccionado,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}
