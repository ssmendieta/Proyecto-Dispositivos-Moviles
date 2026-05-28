import '../../nucleo/utilidades/resultado.dart';
import '../entidades/diagnostico.dart';

abstract class IDiagnosticoRepositorio {
  Future<Resultado<int>> guardar(Diagnostico diagnostico);
  Future<Resultado<Diagnostico>> obtenerPorId(int id);
  Future<Resultado<List<Diagnostico>>> listarTodos();
  Future<Resultado<Null>> eliminar(int id);
}
