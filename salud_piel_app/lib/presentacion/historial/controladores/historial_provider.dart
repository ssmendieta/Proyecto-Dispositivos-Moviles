import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../datos/providers/dependencias_provider.dart';
import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/utilidades/resultado.dart';

class HistorialEstado {
  final List<Diagnostico> analisis;
  final bool cargando;
  final String? error;

  const HistorialEstado({
    required this.analisis,
    required this.cargando,
    this.error,
  });

  HistorialEstado copyWith({
    List<Diagnostico>? analisis,
    bool? cargando,
    String? error,
  }) {
    return HistorialEstado(
      analisis: analisis ?? this.analisis,
      cargando: cargando ?? this.cargando,
      error: error,
    );
  }
}

class HistorialNotifier extends StateNotifier<HistorialEstado> {
  final DiagnosticoCasoUso _casoUso;

  HistorialNotifier({
    required DiagnosticoCasoUso casoUso,
  })  : _casoUso = casoUso,
        super(
          const HistorialEstado(
            analisis: [],
            cargando: true,
          ),
        );

  Future<void> cargarHistorial() async {
    state = state.copyWith(
      cargando: true,
      error: null,
    );

    final resultado = await _casoUso.listarDiagnosticos();

    switch (resultado) {
      case Exito<List<Diagnostico>>():
        state = HistorialEstado(
          analisis: resultado.data,
          cargando: false,
        );

      case Fracaso<List<Diagnostico>>():
        state = HistorialEstado(
          analisis: state.analisis,
          cargando: false,
          error: resultado.mensaje,
        );
    }
  }

  Future<String?> agregarAnalisis(Diagnostico diagnostico) async {
    final resultado = await _casoUso.guardarDiagnostico(diagnostico);

    switch (resultado) {
      case Exito<int>():
        state = state.copyWith(
          analisis: [
            diagnostico,
            ...state.analisis,
          ],
          error: null,
        );
        return null;

      case Fracaso<int>():
        state = state.copyWith(
          error: resultado.mensaje,
        );
        return resultado.mensaje;
    }
  }
}

final historialProvider =
    StateNotifierProvider<HistorialNotifier, HistorialEstado>(
  (ref) {
    final notifier = HistorialNotifier(
      casoUso: ref.watch(diagnosticoCasoUsoProvider),
    );

    Future.microtask(() {
      notifier.cargarHistorial();
    });

    return notifier;
  },
);