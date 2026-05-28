import 'package:get/get.dart';
import '../../../dominio/casos_uso/producto_caso_uso.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/utilidades/resultado.dart';

class ProductosControlador extends GetxController {
  final ProductoCasoUso _casoUso;

  ProductosControlador({required ProductoCasoUso casoUso})
      : _casoUso = casoUso;

  final productos = <Producto>[].obs;
  final busqueda = ''.obs;
  final categoriaSeleccionada = 'Todos'.obs;
  final cargando = true.obs;

  final categorias = [
    'Todos',
    'Limpiadores',
    'Sérums',
    'Cremas',
    'Protector solar',
  ];

  @override
  void onInit() {
    super.onInit();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    cargando.value = true;
    final resultado = await _casoUso.listarProductos();
    switch (resultado) {
      case Exito<List<Producto>>():
        productos.value = resultado.data;
      case Fracaso<List<Producto>>():
        Get.snackbar('Error', resultado.mensaje, snackPosition: SnackPosition.BOTTOM);
    }
    cargando.value = false;
  }

  List<Producto> get productosFiltrados {
    return productos.where((p) {
      final nombre = p.nombre.toLowerCase();
      final query = busqueda.value.toLowerCase();
      final coincideBusqueda = nombre.contains(query);

      final coincideCategoria = categoriaSeleccionada.value == 'Todos' ||
          p.categoria == categoriaSeleccionada.value;

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
