import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/utilidades/resultado.dart';
import '../../autenticacion/controladores/sesion_controlador.dart';

class PerfilControlador {
  final DiagnosticoCasoUso _casoUso;

  PerfilControlador({
    required DiagnosticoCasoUso casoUso,
  }) : _casoUso = casoUso;

  int totalScans = 0;
  double healthScore = 0.0;

  String get nombreUsuario => SesionMemoria.nombreUsuario;

  Future<void> recargarDatos() async {
    final resultado = await _casoUso.listarDiagnosticos();

    switch (resultado) {
      case Exito<List<Diagnostico>>():
        final diagnosticos = resultado.data;
        totalScans = diagnosticos.length;

        if (diagnosticos.isEmpty) {
          healthScore = 0.0;
        } else {
          final promedio = diagnosticos
                  .map((diagnostico) => diagnostico.confianza)
                  .reduce((a, b) => a + b) /
              diagnosticos.length;

          healthScore = (promedio * 100).roundToDouble();
        }

      case Fracaso<List<Diagnostico>>():
        totalScans = 0;
        healthScore = 0.0;
    }
  }

  void cerrarSesion() {
    SesionMemoria.cerrarSesion();
  }
}