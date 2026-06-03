import '../entidades/producto.dart';
import '../enumeraciones/condicion_piel.dart';
import '../enumeraciones/tipo_piel.dart';
import '../repositorios/i_producto_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';

class ProductoCasoUso {
  final IProductoRepositorio _repositorio;

  ProductoCasoUso({required IProductoRepositorio repositorio})
      : _repositorio = repositorio;

  Future<Resultado<List<Producto>>> listarProductos({
    TipoPiel? tipoPiel,
    CondicionPiel? condicion,
  }) async {
    final resultado = await _repositorio.listar(tipoPiel: tipoPiel, condicion: condicion);
    if (resultado case Exito<List<Producto>>(data: [])) {
      return const Fracaso('No se encontraron productos en el catálogo');
    }
    return resultado;
  }

  Future<Resultado<List<Producto>>> buscarProductos(String query) async {
    if (query.trim().isEmpty) {
      return const Fracaso('Ingresa un término de búsqueda');
    }
    if (query.trim().length < 2) {
      return const Fracaso('La búsqueda debe tener al menos 2 caracteres');
    }
    final resultado = await _repositorio.buscar(query.trim());
    if (resultado case Exito<List<Producto>>(data: [])) {
      return Fracaso('No se encontraron productos para "$query"');
    }
    return resultado;
  }
}
