import '../entidades/diagnostico.dart';
import '../repositorios/i_diagnostico_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';

class DiagnosticoCasoUso {
  final IDiagnosticoRepositorio _repositorio;

  DiagnosticoCasoUso({required IDiagnosticoRepositorio repositorio})
      : _repositorio = repositorio;

  Future<Resultado<int>> guardarDiagnostico(Diagnostico diagnostico) async {
    if (diagnostico.imagenPath.isEmpty) {
      return const Fracaso('El diagnóstico debe tener una imagen asociada');
    }
    if (diagnostico.confianza < 0 || diagnostico.confianza > 1) {
      return const Fracaso('La confianza debe estar entre 0 y 1');
    }
    if (diagnostico.fecha.isAfter(DateTime.now())) {
      return const Fracaso('La fecha del diagnóstico no puede ser futura');
    }
    return _repositorio.guardar(diagnostico);
  }

  Future<Resultado<List<Diagnostico>>> listarDiagnosticos() {
    return _repositorio.listarTodos();
  }

  Future<Resultado<Diagnostico>> obtenerDiagnostico(int id) async {
    if (id <= 0) {
      return const Fracaso('El identificador del diagnóstico no es válido');
    }
    return _repositorio.obtenerPorId(id);
  }
}
