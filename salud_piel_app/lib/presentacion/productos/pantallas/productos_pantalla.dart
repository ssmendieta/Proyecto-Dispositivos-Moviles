import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/entidades/producto.dart';
import '../../constantes/colores.dart';
import '../controladores/productos_controlador.dart';
import '../widget/agregar_a_rutina_sheet.dart';
import 'detalle_producto_pantalla.dart';

class ProductosPantalla extends GetView<ProductosControlador> {
  ProductosPantalla({super.key});

  final TextEditingController _buscadorCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catálogo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ColoresApp.textoPrincipal,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Productos recomendados para tu piel',
              style: TextStyle(
                color: ColoresApp.textoSecundario,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _buscadorCtrl,
              onChanged: controller.cambiarBusqueda,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _buildCategoryChips(),

            const SizedBox(height: 20),

            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Obx(() {
      final seleccionado = controller.categoriaSeleccionada.value;

      return SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categorias.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final categoria = controller.categorias[index];
            final chipSeleccionado = seleccionado == categoria;

            return ChoiceChip(
              label: Text(categoria),
              selected: chipSeleccionado,
              onSelected: (_) {
                controller.cambiarCategoria(categoria);
              },
              selectedColor: ColoresApp.primario,
              backgroundColor: Colors.white,
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: chipSeleccionado
                    ? Colors.white
                    : ColoresApp.textoPrincipal,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildProductGrid() {
    return Obx(() {
      final productosFiltrados = controller.productosFiltrados;

      return Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            int columnas = 2;

            if (constraints.maxWidth > 1200) {
              columnas = 5;
            } else if (constraints.maxWidth > 900) {
              columnas = 4;
            } else if (constraints.maxWidth > 600) {
              columnas = 3;
            }

            return GridView.builder(
              itemCount: productosFiltrados.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnas,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: .78,
              ),
              itemBuilder: (context, index) {
                final producto = productosFiltrados[index];

                return _TarjetaProductoCatalogo(
                  producto: producto,
                );
              },
            );
          },
        ),
      );
    });
  }
}

class _TarjetaProductoCatalogo extends StatelessWidget {
  final Producto producto;

  const _TarjetaProductoCatalogo({
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.to(
          () => DetalleProductoPantalla(
            producto: producto,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColoresApp.fondo,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.spa_outlined,
                  size: 42,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              producto.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColoresApp.textoPrincipal,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              producto.marca ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: ColoresApp.textoSecundario,
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 34,
              child: OutlinedButton(
                onPressed: () {
                  Get.bottomSheet(
                    AgregarARutinaSheet(
                      producto: producto,
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: const Text('+ Rutina'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}