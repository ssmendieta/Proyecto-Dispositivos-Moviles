import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dominio/entidades/producto.dart';
import '../../compartidos/widget/imagen_producto.dart';
import '../../constantes/colores.dart';
import '../controladores/productos_provider.dart';
import '../widget/agregar_a_rutina_sheet.dart';
import 'detalle_producto_pantalla.dart';

class ProductosPantalla extends ConsumerStatefulWidget {
  const ProductosPantalla({super.key});

  @override
  ConsumerState<ProductosPantalla> createState() =>
      _ProductosPantallaState();
}

class _ProductosPantallaState extends ConsumerState<ProductosPantalla> {
  final TextEditingController buscadorCtrl = TextEditingController();

  @override
  void dispose() {
    buscadorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(productosProvider);
    final notifier = ref.read(productosProvider.notifier);

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
              controller: buscadorCtrl,
              onChanged: notifier.cambiarBusqueda,
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

            _buildCategoryChips(
              estado: estado,
              notifier: notifier,
            ),

            const SizedBox(height: 20),

            if (estado.cargando)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (estado.error != null)
              Expanded(
                child: Center(
                  child: Text(
                    estado.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: _buildProductGrid(
                  productos: estado.productosFiltrados,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips({
    required ProductosEstado estado,
    required ProductosNotifier notifier,
  }) {
    final seleccionado = estado.categoriaSeleccionada;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: estado.categorias.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final categoria = estado.categorias[index];
          final chipSeleccionado = seleccionado == categoria;

          return ChoiceChip(
            label: Text(categoria),
            selected: chipSeleccionado,
            onSelected: (_) {
              notifier.cambiarCategoria(categoria);
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
  }

  Widget _buildProductGrid({
    required List<Producto> productos,
  }) {
    if (productos.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron productos.',
          style: TextStyle(
            color: ColoresApp.textoSecundario,
          ),
        ),
      );
    }

    return LayoutBuilder(
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
          itemCount: productos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnas,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: .78,
          ),
          itemBuilder: (context, index) {
            final producto = productos[index];

            return _TarjetaProductoCatalogo(
              producto: producto,
            );
          },
        );
      },
    );
  }
}

class _TarjetaProductoCatalogo extends StatelessWidget {
  final Producto producto;

  const _TarjetaProductoCatalogo({
    required this.producto,
  });

  void _abrirDetalle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleProductoPantalla(
          producto: producto,
        ),
      ),
    );
  }

  void _abrirAgregarARutina(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AgregarARutinaSheet(
          producto: producto,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _abrirDetalle(context);
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
              child: ImagenProducto(
                imagenPath: producto.imagenPath,
                borderRadius: 14,
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
                  _abrirAgregarARutina(context);
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