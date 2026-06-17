import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../datos/providers/dependencias_provider.dart';
import '../../../dominio/casos_uso/producto_caso_uso.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/utilidades/resultado.dart';

class ProductosEstado {
  final List<Producto> productos;
  final String busqueda;
  final String categoriaSeleccionada;
  final bool cargando;
  final String? error;

  const ProductosEstado({
    required this.productos,
    required this.busqueda,
    required this.categoriaSeleccionada,
    required this.cargando,
    this.error,
  });

  List<String> get categorias {
    return const [
      'Todos',
      'Limpiadores',
      'Sérums',
      'Cremas',
      'Protector solar',
    ];
  }

  List<Producto> get productosFiltrados {
    return productos.where((producto) {
      final nombre = producto.nombre.toLowerCase();
      final query = busqueda.toLowerCase();

      final coincideBusqueda = nombre.contains(query);

      final coincideCategoria = categoriaSeleccionada == 'Todos' ||
          producto.categoria == categoriaSeleccionada;

      return coincideBusqueda && coincideCategoria;
    }).toList();
  }

  ProductosEstado copyWith({
    List<Producto>? productos,
    String? busqueda,
    String? categoriaSeleccionada,
    bool? cargando,
    String? error,
  }) {
    return ProductosEstado(
      productos: productos ?? this.productos,
      busqueda: busqueda ?? this.busqueda,
      categoriaSeleccionada:
          categoriaSeleccionada ?? this.categoriaSeleccionada,
      cargando: cargando ?? this.cargando,
      error: error ?? this.error,
    );
  }
}

class ProductosNotifier extends StateNotifier<ProductosEstado> {
  final ProductoCasoUso _casoUso;

  ProductosNotifier({
    required ProductoCasoUso casoUso,
  })  : _casoUso = casoUso,
        super(
          const ProductosEstado(
            productos: [],
            busqueda: '',
            categoriaSeleccionada: 'Todos',
            cargando: true,
          ),
        );

  Future<void> cargarProductos() async {
    state = state.copyWith(
      cargando: true,
      error: null,
    );

    final resultado = await _casoUso.listarProductos();

    switch (resultado) {
      case Exito<List<Producto>>():
        state = ProductosEstado(
          productos: resultado.data,
          busqueda: state.busqueda,
          categoriaSeleccionada: state.categoriaSeleccionada,
          cargando: false,
        );

      case Fracaso<List<Producto>>():
        state = ProductosEstado(
          productos: state.productos,
          busqueda: state.busqueda,
          categoriaSeleccionada: state.categoriaSeleccionada,
          cargando: false,
          error: resultado.mensaje,
        );
    }
  }

  void cambiarCategoria(String categoria) {
    state = state.copyWith(
      categoriaSeleccionada: categoria,
    );
  }

  void cambiarBusqueda(String texto) {
    state = state.copyWith(
      busqueda: texto,
    );
  }
}

final productosProvider =
    StateNotifierProvider<ProductosNotifier, ProductosEstado>(
  (ref) {
    final notifier = ProductosNotifier(
      casoUso: ref.watch(productoCasoUsoProvider),
    );

    Future.microtask(() {
      notifier.cargarProductos();
    });

    return notifier;
  },
);