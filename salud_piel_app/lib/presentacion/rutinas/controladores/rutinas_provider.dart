import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../datos/providers/dependencias_provider.dart';
import '../../../dominio/casos_uso/rutina_caso_uso.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/entidades/rutina.dart';
import '../../../dominio/enumeraciones/momento_rutina.dart';
import '../../../dominio/utilidades/resultado.dart';

class RutinasEstado {
  final List<Rutina> rutinas;
  final String filtroSeleccionado;
  final bool cargando;
  final bool mananaSeleccionada;
  final bool nocheSeleccionada;

  const RutinasEstado({
    required this.rutinas,
    required this.filtroSeleccionado,
    required this.cargando,
    required this.mananaSeleccionada,
    required this.nocheSeleccionada,
  });

  RutinasEstado copyWith({
    List<Rutina>? rutinas,
    String? filtroSeleccionado,
    bool? cargando,
    bool? mananaSeleccionada,
    bool? nocheSeleccionada,
  }) {
    return RutinasEstado(
      rutinas: rutinas ?? this.rutinas,
      filtroSeleccionado: filtroSeleccionado ?? this.filtroSeleccionado,
      cargando: cargando ?? this.cargando,
      mananaSeleccionada: mananaSeleccionada ?? this.mananaSeleccionada,
      nocheSeleccionada: nocheSeleccionada ?? this.nocheSeleccionada,
    );
  }

  Rutina? _rutinaPorMomento(MomentoRutina momento) {
    for (final rutina in rutinas) {
      if (rutina.momento == momento) {
        return rutina;
      }
    }
    return null;
  }

  List<RutinaProducto> get rutinaManana {
    return _rutinaPorMomento(MomentoRutina.maniana)?.productos ?? [];
  }

  List<RutinaProducto> get rutinaNoche {
    return _rutinaPorMomento(MomentoRutina.noche)?.productos ?? [];
  }

  int get completadosManana {
    return rutinaManana.where((rp) => rp.completado).length;
  }

  int get completadosNoche {
    return rutinaNoche.where((rp) => rp.completado).length;
  }

  int get totalProductos {
    return rutinaManana.length + rutinaNoche.length;
  }

  int get totalCompletados {
    return completadosManana + completadosNoche;
  }

  double get progreso {
    if (totalProductos == 0) {
      return 0.0;
    }

    return totalCompletados / totalProductos;
  }
}

class RutinasNotifier extends StateNotifier<RutinasEstado> {
  final RutinaCasoUso _casoUso;

  RutinasNotifier({
    required RutinaCasoUso casoUso,
  })  : _casoUso = casoUso,
        super(
          const RutinasEstado(
            rutinas: [],
            filtroSeleccionado: 'Todas',
            cargando: true,
            mananaSeleccionada: false,
            nocheSeleccionada: false,
          ),
        );

  Rutina? _rutinaPorMomento(MomentoRutina momento) {
    for (final rutina in state.rutinas) {
      if (rutina.momento == momento) {
        return rutina;
      }
    }

    return null;
  }

  Future<void> cargarRutinas() async {
    state = state.copyWith(
      cargando: true,
    );

    final resultado = await _casoUso.listarRutinas();

    switch (resultado) {
      case Exito<List<Rutina>>():
        state = state.copyWith(
          rutinas: resultado.data,
          cargando: false,
        );

      case Fracaso<List<Rutina>>():
        state = state.copyWith(
          cargando: false,
        );
    }
  }

  void cambiarFiltro(String filtro) {
    state = state.copyWith(
      filtroSeleccionado: filtro,
    );
  }

  void toggleMananaSheet() {
    state = state.copyWith(
      mananaSeleccionada: !state.mananaSeleccionada,
    );
  }

  void toggleNocheSheet() {
    state = state.copyWith(
      nocheSeleccionada: !state.nocheSeleccionada,
    );
  }

  void resetSheetState() {
    state = state.copyWith(
      mananaSeleccionada: false,
      nocheSeleccionada: false,
    );
  }

  Future<void> agregarProducto({
    required Producto producto,
    required bool manana,
    required bool noche,
  }) async {
    if (manana) {
      await _agregarAMomento(
        MomentoRutina.maniana,
        producto,
      );
    }

    if (noche) {
      await _agregarAMomento(
        MomentoRutina.noche,
        producto,
      );
    }

    await cargarRutinas();
  }

  Future<void> _agregarAMomento(
    MomentoRutina momento,
    Producto producto,
  ) async {
    await _casoUso.agregarProductoARutina(
      momento,
      producto,
    );
  }

  Future<void> toggleManana(int index) async {
    final productos = state.rutinaManana;

    if (index >= productos.length) {
      return;
    }

    final rutina = _rutinaPorMomento(MomentoRutina.maniana);

    if (rutina == null) {
      return;
    }

    final rp = productos[index];

    await _casoUso.marcarCompletado(
      rutina.id,
      rp.producto.id,
      !rp.completado,
    );

    await cargarRutinas();
  }

  Future<void> toggleNoche(int index) async {
    final productos = state.rutinaNoche;

    if (index >= productos.length) {
      return;
    }

    final rutina = _rutinaPorMomento(MomentoRutina.noche);

    if (rutina == null) {
      return;
    }

    final rp = productos[index];

    await _casoUso.marcarCompletado(
      rutina.id,
      rp.producto.id,
      !rp.completado,
    );

    await cargarRutinas();
  }

  Future<void> eliminarManana(int index) async {
    final productos = state.rutinaManana;

    if (index >= productos.length) {
      return;
    }

    final rutina = _rutinaPorMomento(MomentoRutina.maniana);

    if (rutina == null) {
      return;
    }

    final rp = productos[index];

    await _casoUso.quitarProducto(
      rutina.id,
      rp.producto.id,
    );

    await cargarRutinas();
  }

  Future<void> eliminarNoche(int index) async {
    final productos = state.rutinaNoche;

    if (index >= productos.length) {
      return;
    }

    final rutina = _rutinaPorMomento(MomentoRutina.noche);

    if (rutina == null) {
      return;
    }

    final rp = productos[index];

    await _casoUso.quitarProducto(
      rutina.id,
      rp.producto.id,
    );

    await cargarRutinas();
  }

  Future<void> reordenarManana(
    int oldIndex,
    int newIndex,
  ) async {
    final rutina = _rutinaPorMomento(MomentoRutina.maniana);

    if (rutina == null) {
      return;
    }

    final productos = List<RutinaProducto>.from(
      state.rutinaManana,
    );

    if (productos.isEmpty || oldIndex >= productos.length) {
      return;
    }

    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = productos.removeAt(oldIndex);
    productos.insert(adjustedIndex, item);

    await _casoUso.reordenarProductos(
      rutina.id,
      productos,
    );

    await cargarRutinas();
  }

  Future<void> reordenarNoche(
    int oldIndex,
    int newIndex,
  ) async {
    final rutina = _rutinaPorMomento(MomentoRutina.noche);

    if (rutina == null) {
      return;
    }

    final productos = List<RutinaProducto>.from(
      state.rutinaNoche,
    );

    if (productos.isEmpty || oldIndex >= productos.length) {
      return;
    }

    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = productos.removeAt(oldIndex);
    productos.insert(adjustedIndex, item);

    await _casoUso.reordenarProductos(
      rutina.id,
      productos,
    );

    await cargarRutinas();
  }
}

final rutinasProvider =
    StateNotifierProvider<RutinasNotifier, RutinasEstado>(
  (ref) {
    final notifier = RutinasNotifier(
      casoUso: ref.watch(rutinaCasoUsoProvider),
    );

    Future.microtask(() {
      notifier.cargarRutinas();
    });

    return notifier;
  },
);