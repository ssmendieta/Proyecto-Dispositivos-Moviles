import '../entidades/producto.dart';
import '../enumeraciones/condicion_piel.dart';
import '../enumeraciones/tipo_piel.dart';

abstract class IProductoRepositorio {
  Future<List<Producto>> listar({TipoPiel? tipoPiel, CondicionPiel? condicion});
  Future<Producto?> obtenerPorId(int id);
  Future<List<Producto>> buscar(String query);
}
