import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../../dominio/entidades/rutina.dart';
import '../../rutas/app_rutas.dart';
import '../controladores/rutinas_controlador.dart';

class RutinasPantalla extends GetView<RutinasControlador> {
  const RutinasPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColoresApp.fondo,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.inicioControlador.cambiarPagina(3);
          },
          backgroundColor: ColoresApp.primario,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFE6D5F7),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'SkinGPT',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildProgressCard(),

              const SizedBox(height: 24),

              _buildFiltersAndSections(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Obx(() {
      controller.rutinas.length;
      final progreso = controller.progreso;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progreso,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(ColoresApp.primario),
                  ),
                  Text(
                    '${(progreso * 100).round()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuidado del Día',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.totalProductos == 0
                        ? 'Agrega productos para comenzar tu rutina.'
                        : '¡Excelente progreso! Has completado ${controller.totalCompletados} de ${controller.totalProductos} pasos.',
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFiltersAndSections() {
    return Obx(() {
      final filtro = controller.filtroSeleccionado.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _chipFiltro(
                texto: 'Todas',
                seleccionado: filtro == 'Todas',
                onTap: () => controller.cambiarFiltro('Todas'),
              ),
              const SizedBox(width: 10),
              _chipFiltro(
                texto: 'Mañana',
                seleccionado: filtro == 'Mañana',
                onTap: () => controller.cambiarFiltro('Mañana'),
              ),
              const SizedBox(width: 10),
              _chipFiltro(
                texto: 'Noche',
                seleccionado: filtro == 'Noche',
                onTap: () => controller.cambiarFiltro('Noche'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (filtro == 'Todas' || filtro == 'Mañana') ...[
            _tituloSeccion(
              titulo: 'MAÑANA',
              icono: Icons.wb_sunny_outlined,
              textoDerecha: controller.rutinaManana.isEmpty
                  ? ''
                  : '${controller.completadosManana}/${controller.rutinaManana.length} Pasos',
            ),
            const SizedBox(height: 12),
            _listaRutina(
              productos: controller.rutinaManana,
              vacio: 'No tienes productos en la rutina de mañana.',
              onToggle: controller.toggleManana,
            ),
            const SizedBox(height: 22),
          ],

          if (filtro == 'Todas' || filtro == 'Noche') ...[
            _tituloSeccion(
              titulo: 'NOCHE',
              icono: Icons.nightlight_round,
              textoDerecha: controller.rutinaNoche.isEmpty
                  ? ''
                  : '${controller.completadosNoche}/${controller.rutinaNoche.length} Pasos',
            ),
            const SizedBox(height: 12),
            _listaRutina(
              productos: controller.rutinaNoche,
              vacio: 'No tienes productos en la rutina de noche.',
              onToggle: controller.toggleNoche,
            ),
            const SizedBox(height: 22),
          ],

          TextButton.icon(
            onPressed: () {
              Get.toNamed(AppRutas.gestionarRutina);
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar rutina'),
            style: TextButton.styleFrom(
              foregroundColor: ColoresApp.primario,
            ),
          ),
          const SizedBox(height: 90),
        ],
      );
    });
  }

  Widget _chipFiltro({
    required String texto,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: seleccionado ? ColoresApp.primario : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: seleccionado ? Colors.white : ColoresApp.textoPrincipal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _tituloSeccion({
    required String titulo,
    required IconData icono,
    required String textoDerecha,
  }) {
    return Row(
      children: [
        Icon(icono, size: 18, color: ColoresApp.textoSecundario),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColoresApp.textoSecundario,
            letterSpacing: 1,
          ),
        ),
        const Spacer(),
        Text(
          textoDerecha,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColoresApp.primario,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _listaRutina({
    required List<RutinaProducto> productos,
    required String vacio,
    required Future<void> Function(int) onToggle,
  }) {
    if (productos.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          vacio,
          style: TextStyle(color: ColoresApp.textoSecundario),
        ),
      );
    }

    return Column(
      children: List.generate(
        productos.length,
        (index) {
          final rp = productos[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
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
                        rp.producto.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColoresApp.textoPrincipal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rp.producto.marca ?? '',
                        style: TextStyle(
                          color: ColoresApp.textoSecundario,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => onToggle(index),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: rp.completado ? ColoresApp.exito : Colors.transparent,
                      border: Border.all(
                        color: rp.completado ? ColoresApp.exito : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: rp.completado
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
