import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../controladores/productos_controlador.dart';
import '../widget/agregar_a_rutina_sheet.dart';

class ProductosPantalla extends StatelessWidget {
  const ProductosPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = Get.find<ProductosControlador>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final productosFiltrados = controlador.productos.where((producto) {
            final nombre = producto['nombre']!.toLowerCase();
            final busqueda = controlador.busqueda.value.toLowerCase();

            final coincideBusqueda = nombre.contains(busqueda);

            final coincideCategoria =
                controlador.categoriaSeleccionada.value == 'Todos' ||
                producto['categoria'] == controlador.categoriaSeleccionada.value;

            return coincideBusqueda && coincideCategoria;
          }).toList();

          return Column(
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
                onChanged: controlador.cambiarBusqueda,
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

              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controlador.categorias.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final categoria = controlador.categorias[index];
                    final seleccionado =
                        controlador.categoriaSeleccionada.value == categoria;

                    return ChoiceChip(
                      label: Text(categoria),
                      selected: seleccionado,
                      onSelected: (_) {
                        controlador.cambiarCategoria(categoria);
                      },
                      selectedColor: ColoresApp.primario,
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      labelStyle: TextStyle(
                        color: seleccionado
                            ? Colors.white
                            : ColoresApp.textoPrincipal,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
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
                          nombre: producto['nombre']!,
                          marca: producto['marca']!,
                          compatibilidad: producto['compatibilidad']!,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _TarjetaProductoCatalogo extends StatelessWidget {
  final String nombre;
  final String marca;
  final String compatibilidad;

  const _TarjetaProductoCatalogo({
    required this.nombre,
    required this.marca,
    required this.compatibilidad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            nombre,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColoresApp.textoPrincipal,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            marca,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: ColoresApp.textoSecundario,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: ColoresApp.acento.withOpacity(.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$compatibilidad compatible',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: ColoresApp.primario,
              ),
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
                    nombreProducto: nombre,
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
    );
  }
}