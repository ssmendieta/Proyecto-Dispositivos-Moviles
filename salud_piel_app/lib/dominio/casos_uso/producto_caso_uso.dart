import '../entidades/producto.dart';
import '../repositorios/i_producto_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';

class ProductoCasoUso {
  final IProductoRepositorio _repositorio;

  ProductoCasoUso({required IProductoRepositorio repositorio})
      : _repositorio = repositorio;

  Future<Resultado<List<Producto>>> listarProductos() {
    return _repositorio.listar();
  }
}
