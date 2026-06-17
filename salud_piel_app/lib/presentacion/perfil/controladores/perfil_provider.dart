import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../datos/providers/dependencias_provider.dart';
import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/utilidades/resultado.dart';

class PerfilEstado {
  final int totalScans;
  final double healthScore;
  final bool cargando;

  const PerfilEstado({
    required this.totalScans,
    required this.healthScore,
    required this.cargando,
  });

  PerfilEstado copyWith({
    int? totalScans,
    double? healthScore,
    bool? cargando,
  }) {
    return PerfilEstado(
      totalScans: totalScans ?? this.totalScans,
      healthScore: healthScore ?? this.healthScore,
      cargando: cargando ?? this.cargando,
    );
  }
}

class PerfilNotifier extends StateNotifier<PerfilEstado> {
  final DiagnosticoCasoUso _casoUso;

  PerfilNotifier({
    required DiagnosticoCasoUso casoUso,
  })  : _casoUso = casoUso,
        super(
          const PerfilEstado(
            totalScans: 0,
            healthScore: 0.0,
            cargando: true,
          ),
        );

  Future<void> cargarDatos() async {
    state = state.copyWith(
      cargando: true,
    );

    final resultado = await _casoUso.listarDiagnosticos();

    switch (resultado) {
      case Exito<List<Diagnostico>>():
        final diagnosticos = resultado.data;

        if (diagnosticos.isEmpty) {
          state = const PerfilEstado(
            totalScans: 0,
            healthScore: 0.0,
            cargando: false,
          );
          return;
        }

        final promedio = diagnosticos
                .map((diagnostico) => diagnostico.confianza)
                .reduce((a, b) => a + b) /
            diagnosticos.length;

        state = PerfilEstado(
          totalScans: diagnosticos.length,
          healthScore: (promedio * 100).roundToDouble(),
          cargando: false,
        );

      case Fracaso<List<Diagnostico>>():
        state = const PerfilEstado(
          totalScans: 0,
          healthScore: 0.0,
          cargando: false,
        );
    }
  }
}

final perfilProvider =
    StateNotifierProvider<PerfilNotifier, PerfilEstado>(
  (ref) {
    final notifier = PerfilNotifier(
      casoUso: ref.watch(diagnosticoCasoUsoProvider),
    );

    Future.microtask(() {
      notifier.cargarDatos();
    });

    return notifier;
  },
);