import 'package:get/get.dart';

import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../../dominio/utilidades/resultado.dart';

class DiagnosticoControlador extends GetxController {
  final DiagnosticoCasoUso _casoUso;

  DiagnosticoControlador({
    required DiagnosticoCasoUso casoUso,
  }) : _casoUso = casoUso;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      imagenPath.value = args;
    }
  }

  final condicion = CondicionPiel.normal.obs;
  final confianza = 0.0.obs;
  final descripcion = ''.obs;
  final imagenPath = ''.obs;
  final productosRecomendados = <Producto>[].obs;
  final guardando = false.obs;

  void cargarResultado({
    required CondicionPiel cond,
    required double conf,
    String? desc,
    String? imgPath,
    List<Producto>? productos,
  }) {
    condicion.value = cond;
    confianza.value = conf;
    descripcion.value = desc ?? '';
    imagenPath.value = imgPath ?? '';
    productosRecomendados.value = productos ?? [];
  }

  Future<void> guardarEnHistorial() async {
    guardando.value = true;

    final diagnostico = Diagnostico(
      id: 0,
      imagenPath: imagenPath.value,
      condicion: condicion.value,
      confianza: confianza.value,
      fecha: DateTime.now(),
      descripcion: descripcion.value.isNotEmpty ? descripcion.value : null,
      productosRecomendados: List.from(productosRecomendados),
    );

    final resultado = await _casoUso.guardarDiagnostico(diagnostico);
    switch (resultado) {
      case Exito<int>():
        Get.snackbar('Guardado', 'Diagnóstico guardado en historial.', snackPosition: SnackPosition.BOTTOM);
      case Fracaso<int>():
        Get.snackbar('Error', resultado.mensaje, snackPosition: SnackPosition.BOTTOM);
    }
    guardando.value = false;
  }
}
