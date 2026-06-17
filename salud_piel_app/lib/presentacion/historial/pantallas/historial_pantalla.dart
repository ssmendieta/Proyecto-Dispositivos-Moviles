import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constantes/colores.dart';
import '../controladores/historial_provider.dart';
import '../widget/tarjeta_historial.dart';

class HistorialPantalla extends ConsumerWidget {
  const HistorialPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(historialProvider);
    final notifier = ref.read(historialProvider.notifier);

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Historial de Análisis',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.textoPrincipal,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Todos',
                  style: TextStyle(
                    color: ColoresApp.textoSecundario,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Expanded(
                child: estado.cargando
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: notifier.cargarHistorial,
                        child: _contenidoHistorial(
                          context: context,
                          estado: estado,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contenidoHistorial({
    required BuildContext context,
    required HistorialEstado estado,
  }) {
    if (estado.error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Text(
              estado.error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColoresApp.textoSecundario,
              ),
            ),
          ),
        ],
      );
    }

    if (estado.analisis.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Text(
              'Todavía no tienes análisis guardados.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColoresApp.textoSecundario,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: estado.analisis.length + 1,
      itemBuilder: (context, index) {
        if (index == estado.analisis.length) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 30,
            ),
            child: Center(
              child: SizedBox(
                width: 240,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_down),
                  label: const Text('Cargar más análisis'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColoresApp.primario,
                    side: BorderSide(
                      color: ColoresApp.primario,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        final item = estado.analisis[index];

        return TarjetaHistorial(
          diagnostico: item,
        );
      },
    );
  }
}