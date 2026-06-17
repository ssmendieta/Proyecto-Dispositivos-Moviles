import '../../../dominio/casos_uso/producto_caso_uso.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/utilidades/resultado.dart';

class ValorCompat<T> {
  T value;

  ValorCompat(this.value);
}

class ProductosControlador {
  final ProductoCasoUso _casoUso;

  ProductosControlador({
    required ProductoCasoUso casoUso,
  }) : _casoUso = casoUso {
    cargarProductos();
  }

  final productos = <Producto>[];
  final busqueda = ValorCompat<String>('');
  final categoriaSeleccionada = ValorCompat<String>('Todos');
  final cargando = ValorCompat<bool>(true);

  final categorias = const [
    'Todos',
    'Limpiadores',
    'Sérums',
    'Cremas',
    'Protector solar',
  ];

  Future<void> cargarProductos() async {
    cargando.value = true;

    final resultado = await _casoUso.listarProductos();

    switch (resultado) {
      case Exito<List<Producto>>():
        productos
          ..clear()
          ..addAll(resultado.data);

      case Fracaso<List<Producto>>():
        break;
    }

    cargando.value = false;
  }

  List<Producto> get productosFiltrados {
    return productos.where((producto) {
      final nombre = producto.nombre.toLowerCase();
      final query = busqueda.value.toLowerCase();

      final coincideBusqueda = nombre.contains(query);

      final coincideCategoria = categoriaSeleccionada.value == 'Todos' ||
          producto.categoria == categoriaSeleccionada.value;

      return coincideBusqueda && coincideCategoria;
    }).toList();
  }

  void cambiarCategoria(String categoria) {
    categoriaSeleccionada.value = categoria;
  }

  void cambiarBusqueda(String texto) {
    busqueda.value = texto;
  }
}