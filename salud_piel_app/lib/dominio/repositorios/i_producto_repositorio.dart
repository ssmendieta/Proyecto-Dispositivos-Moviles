import '../../nucleo/utilidades/resultado.dart';
import '../entidades/producto.dart';
import '../enumeraciones/condicion_piel.dart';
import '../enumeraciones/tipo_piel.dart';

abstract class IProductoRepositorio {
  Future<Resultado<List<Producto>>> listar({TipoPiel? tipoPiel, CondicionPiel? condicion});
  Future<Resultado<Producto>> obtenerPorId(int id);
  Future<Resultado<List<Producto>>> buscar(String query);
}
