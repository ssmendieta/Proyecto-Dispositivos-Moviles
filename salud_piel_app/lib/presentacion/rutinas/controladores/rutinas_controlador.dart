import 'package:get/get.dart';

import '../../../dominio/casos_uso/rutina_caso_uso.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/entidades/rutina.dart';
import '../../../dominio/enumeraciones/momento_rutina.dart';
import '../../../nucleo/utilidades/resultado.dart';
import '../../inicio/controladores/inicio_controlador.dart';

class RutinasControlador extends GetxController {
  final RutinaCasoUso _casoUso;
  final InicioControlador inicioControlador;

  RutinasControlador({
    required RutinaCasoUso casoUso,
    required this.inicioControlador,
  }) : _casoUso = casoUso;

  final rutinas = <Rutina>[].obs;
  final filtroSeleccionado = 'Todas'.obs;
  final cargando = true.obs;
  final mananaSeleccionada = false.obs;
  final nocheSeleccionada = false.obs;

  @override
  void onInit() {
    super.onInit();
    _cargarRutinas();
  }

  Future<void> _cargarRutinas() async {
    cargando.value = true;
    final resultado = await _casoUso.listarRutinas();
    switch (resultado) {
      case Exito<List<Rutina>>():
        rutinas.value = resultado.data;
      case Fracaso<List<Rutina>>():
        Get.snackbar('Error', resultado.mensaje, snackPosition: SnackPosition.BOTTOM);
    }
    cargando.value = false;
  }

  List<RutinaProducto> get rutinaManana {
    final rutina = rutinas.where((r) => r.momento == MomentoRutina.maniana).firstOrNull;
    return rutina?.productos ?? [];
  }

  List<RutinaProducto> get rutinaNoche {
    final rutina = rutinas.where((r) => r.momento == MomentoRutina.noche).firstOrNull;
    return rutina?.productos ?? [];
  }

  int get completadosManana => rutinaManana.where((rp) => rp.completado).length;
  int get completadosNoche => rutinaNoche.where((rp) => rp.completado).length;
  int get totalProductos => rutinaManana.length + rutinaNoche.length;
  int get totalCompletados => completadosManana + completadosNoche;
  double get progreso => totalProductos == 0 ? 0.0 : totalCompletados / totalProductos;

  void cambiarFiltro(String filtro) {
    filtroSeleccionado.value = filtro;
  }

  void toggleMananaSheet() {
    mananaSeleccionada.value = !mananaSeleccionada.value;
  }

  void toggleNocheSheet() {
    nocheSeleccionada.value = !nocheSeleccionada.value;
  }

  void resetSheetState() {
    mananaSeleccionada.value = false;
    nocheSeleccionada.value = false;
  }

  Future<void> agregarProducto({
    required Producto producto,
    required bool manana,
    required bool noche,
  }) async {
    if (manana) {
      await _agregarAMomento(MomentoRutina.maniana, producto);
    }
    if (noche) {
      await _agregarAMomento(MomentoRutina.noche, producto);
    }
    await _cargarRutinas();
  }

  Future<void> _agregarAMomento(MomentoRutina momento, Producto producto) async {
    final resultado = await _casoUso.agregarProductoARutina(momento, producto);
    if (resultado case Fracaso<Null>()) {
      Get.snackbar('Error', resultado.mensaje, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> toggleManana(int index) async {
    final productos = rutinaManana;
    if (index >= productos.length) return;
    final rp = productos[index];
    final rutina = rutinas.where((r) => r.momento == MomentoRutina.maniana).first;
    await _casoUso.marcarCompletado(rutina.id, rp.producto.id, !rp.completado);
    await _cargarRutinas();
  }

  Future<void> toggleNoche(int index) async {
    final productos = rutinaNoche;
    if (index >= productos.length) return;
    final rp = productos[index];
    final rutina = rutinas.where((r) => r.momento == MomentoRutina.noche).first;
    await _casoUso.marcarCompletado(rutina.id, rp.producto.id, !rp.completado);
    await _cargarRutinas();
  }

  Future<void> eliminarManana(int index) async {
    final productos = rutinaManana;
    if (index >= productos.length) return;
    final rp = productos[index];
    final rutina = rutinas.where((r) => r.momento == MomentoRutina.maniana).first;
    await _casoUso.quitarProducto(rutina.id, rp.producto.id);
    await _cargarRutinas();
  }

  Future<void> eliminarNoche(int index) async {
    final productos = rutinaNoche;
    if (index >= productos.length) return;
    final rp = productos[index];
    final rutina = rutinas.where((r) => r.momento == MomentoRutina.noche).first;
    await _casoUso.quitarProducto(rutina.id, rp.producto.id);
    await _cargarRutinas();
  }

  Future<void> reordenarManana(int oldIndex, int newIndex) async {
    final productos = rutinaManana;
    if (productos.isEmpty) return;
    final rutina = rutinas.where((r) => r.momento == MomentoRutina.maniana).first;

    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = productos.removeAt(oldIndex);
    productos.insert(adjustedIndex, item);

    await _casoUso.reordenarProductos(rutina.id, productos);
    await _cargarRutinas();
  }

  Future<void> reordenarNoche(int oldIndex, int newIndex) async {
    final productos = rutinaNoche;
    if (productos.isEmpty) return;
    final rutina = rutinas.where((r) => r.momento == MomentoRutina.noche).first;

    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = productos.removeAt(oldIndex);
    productos.insert(adjustedIndex, item);

    await _casoUso.reordenarProductos(rutina.id, productos);
    await _cargarRutinas();
  }
}
