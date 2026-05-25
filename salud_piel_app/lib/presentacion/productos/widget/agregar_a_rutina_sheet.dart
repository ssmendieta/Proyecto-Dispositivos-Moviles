import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../rutinas/controladores/rutinas_controlador.dart';

class AgregarARutinaSheet extends StatelessWidget {
  final String nombreProducto;

  AgregarARutinaSheet({
    super.key,
    required this.nombreProducto,
  });

  final mananaSeleccionada = false.obs;
  final nocheSeleccionada = false.obs;

  @override
  Widget build(BuildContext context) {
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
              nombreProducto,
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
              seleccionado: mananaSeleccionada.value,
              onTap: () {
                mananaSeleccionada.value = !mananaSeleccionada.value;
              },
            ),

            const SizedBox(height: 12),

            _opcionRutina(
              icono: Icons.nightlight_round,
              titulo: 'Rutina de Noche',
              descripcion: 'Ideal para reparación, tratamiento y nutrición',
              seleccionado: nocheSeleccionada.value,
              onTap: () {
                nocheSeleccionada.value = !nocheSeleccionada.value;
              },
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();

                  String rutina = '';

                  if (mananaSeleccionada.value && nocheSeleccionada.value) {
                    rutina = 'mañana y noche';
                  } else if (mananaSeleccionada.value) {
                    rutina = 'mañana';
                  } else if (nocheSeleccionada.value) {
                    rutina = 'noche';
                  } else {
                    rutina = 'sin rutina seleccionada';
                  }

                 final rutinasControlador =
                  Get.find<RutinasControlador>();

              rutinasControlador.agregarProducto(
                nombre: nombreProducto,
                marca: 'SkinGPT',
                manana: mananaSeleccionada.value,
                noche: nocheSeleccionada.value,
              );

              Get.snackbar(
                'Producto añadido',
                '$nombreProducto fue añadido correctamente',
                snackPosition: SnackPosition.BOTTOM,
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
              ? ColoresApp.acento.withOpacity(.18)
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