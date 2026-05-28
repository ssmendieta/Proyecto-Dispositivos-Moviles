import 'package:get/get.dart';

import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../autenticacion/controladores/sesion_controlador.dart';
import '../../../nucleo/utilidades/resultado.dart';
import '../../rutas/app_rutas.dart';

class PerfilControlador extends GetxController {
  final SesionControlador _sesionControlador;
  final DiagnosticoCasoUso _casoUso;

  PerfilControlador({
    required SesionControlador sesionControlador,
    required DiagnosticoCasoUso casoUso,
  })  : _sesionControlador = sesionControlador,
        _casoUso = casoUso;

  final totalScans = 0.obs;
  final healthScore = 0.0.obs;

  String get nombreUsuario =>
      _sesionControlador.nombreUsuario;

  @override
  void onInit() {
    super.onInit();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final resultado = await _casoUso.listarDiagnosticos();
    switch (resultado) {
      case Exito<List<Diagnostico>>():
        final diagnosticos = resultado.data;
        totalScans.value = diagnosticos.length;

        if (diagnosticos.isEmpty) {
          healthScore.value = 0.0;
        } else {
          final promedio = diagnosticos
                  .map((d) => d.confianza)
                  .reduce((a, b) => a + b) /
              diagnosticos.length;
          healthScore.value = (promedio * 100).roundToDouble();
        }
      case Fracaso<List<Diagnostico>>():
        totalScans.value = 0;
        healthScore.value = 0.0;
    }
  }

  void irAHistorial() => Get.toNamed(AppRutas.historial);

  void cerrarSesion() {
    _sesionControlador.cerrarSesion();
  }
}
