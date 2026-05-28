import '../entidades/diagnostico.dart';
import '../repositorios/i_diagnostico_repositorio.dart';
import '../../nucleo/utilidades/resultado.dart';

class DiagnosticoCasoUso {
  final IDiagnosticoRepositorio _repositorio;

  DiagnosticoCasoUso({required IDiagnosticoRepositorio repositorio})
      : _repositorio = repositorio;

  Future<Resultado<int>> guardarDiagnostico(Diagnostico diagnostico) {
    return _repositorio.guardar(diagnostico);
  }

  Future<Resultado<List<Diagnostico>>> listarDiagnosticos() {
    return _repositorio.listarTodos();
  }

  Future<Resultado<Diagnostico>> obtenerDiagnostico(int id) {
    return _repositorio.obtenerPorId(id);
  }
}
