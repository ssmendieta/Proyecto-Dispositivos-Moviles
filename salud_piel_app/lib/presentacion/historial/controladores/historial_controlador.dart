import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/utilidades/resultado.dart';

class ValorCompat<T> {
  T value;

  ValorCompat(this.value);
}

class HistorialControlador {
  final DiagnosticoCasoUso _casoUso;

  HistorialControlador({
    required DiagnosticoCasoUso casoUso,
  }) : _casoUso = casoUso {
    cargarHistorial();
  }

  final analisis = <Diagnostico>[];
  final cargando = ValorCompat<bool>(true);

  Future<void> cargarHistorial() async {
    cargando.value = true;

    final resultado = await _casoUso.listarDiagnosticos();

    switch (resultado) {
      case Exito<List<Diagnostico>>():
        analisis
          ..clear()
          ..addAll(resultado.data);

      case Fracaso<List<Diagnostico>>():
        break;
    }

    cargando.value = false;
  }

  Future<void> agregarAnalisis(Diagnostico diagnostico) async {
    final resultado = await _casoUso.guardarDiagnostico(diagnostico);

    switch (resultado) {
      case Exito<int>():
        analisis.insert(0, diagnostico);

      case Fracaso<int>():
        break;
    }
  }
}