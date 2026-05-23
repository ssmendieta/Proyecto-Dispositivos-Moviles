import '../entidades/diagnostico.dart';

abstract class IDiagnosticoRepositorio {
  Future<int> guardar(Diagnostico diagnostico);
  Future<Diagnostico?> obtenerPorId(int id);
  Future<List<Diagnostico>> listarTodos();
  Future<void> eliminar(int id);
}
