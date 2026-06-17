import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../datos/servicios/ml_servicio.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../constantes/colores.dart';
import '../../historial/controladores/historial_provider.dart';
import '../../perfil/controladores/perfil_provider.dart';
import '../../rutas/app_rutas.dart';
import '../controladores/diagnostico_provider.dart';

class DiagnosticoPantalla extends ConsumerStatefulWidget {
  final Object? controller;

  const DiagnosticoPantalla({
    super.key,
    this.controller,
  });

  @override
  ConsumerState<DiagnosticoPantalla> createState() =>
      _DiagnosticoPantallaState();
}

class _DiagnosticoPantallaState extends ConsumerState<DiagnosticoPantalla> {
  bool _argumentosCargados = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (_argumentosCargados) {
    return;
  }

  _argumentosCargados = true;

  final argumentos = ModalRoute.of(context)?.settings.arguments;

  if (argumentos is ResultadoAnalisis) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final notifier = ref.read(diagnosticoProvider.notifier);

      notifier.cargarDesdeResultadoML(argumentos);
      notifier.cargarInformacionIA();
    });
  }
}

  Future<void> _guardarEnHistorial() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final error = await ref
        .read(diagnosticoProvider.notifier)
        .guardarEnHistorial();

    if (!mounted) {
      return;
    }

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await ref.read(historialProvider.notifier).cargarHistorial();
    await ref.read(perfilProvider.notifier).cargarDatos();

    if (!mounted) {
      return;
    }

    messenger.showSnackBar(
      const SnackBar(
        content: Text('Diagnóstico guardado en historial.'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    navigator.pushReplacementNamed(
      AppRutas.historial,
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(diagnosticoProvider);

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'SkinGPT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: estado.resultadoCargado
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _encabezadoResultado(estado),

                  const SizedBox(height: 20),

                  _imagenResultado(estado.imagenPath),

                  const SizedBox(height: 20),

                  _seccionCondicion(estado),

                  if (estado.informacionCondicion == null &&
                      !estado.cargandoInfoIA) ...[
                    const SizedBox(height: 20),
                    _seccionResultados(estado),
                  ],

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed:
                          estado.guardando ? null : _guardarEnHistorial,
                      icon: Icon(
                        estado.guardando
                            ? Icons.hourglass_top
                            : Icons.bookmark_border,
                      ),
                      label: Text(
                        estado.guardando
                            ? 'Guardando...'
                            : 'Guardar en historial',
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No se encontró información del análisis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColoresApp.textoSecundario,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _encabezadoResultado(DiagnosticoEstado estado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: ColoresApp.acento.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ANÁLISIS COMPLETADO',
              style: TextStyle(
                color: ColoresApp.primario,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            estado.tituloResultado.isNotEmpty
                ? estado.tituloResultado
                : estado.condicion.displayName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColoresApp.textoPrincipal,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Resultado orientativo',
            style: TextStyle(
              color: ColoresApp.textoSecundario,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagenResultado(String path) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF102A35),
        borderRadius: BorderRadius.circular(22),
      ),
      child: path.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 80,
                ),
              ),
            )
          : const Icon(
              Icons.image_search,
              color: Colors.white,
              size: 80,
            ),
    );
  }

  Widget _seccionCondicion(DiagnosticoEstado estado) {
    final info = estado.informacionCondicion;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xFF7B5EA7),
              ),
              SizedBox(width: 8),
              Text(
                'Sobre esta condición',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (estado.cargandoInfoIA)
            const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Consultando con IA...',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 14,
                  ),
                ),
              ],
            )
          else if (info != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.descripcion,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    height: 1.5,
                  ),
                ),

                if (info.causas.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    '¿Por qué se produce?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...info.causas.map(
                    (causa) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              color: Color(0xFF7B5EA7),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              causa,
                              style: const TextStyle(
                                color: Color(0xFF555555),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (info.recomendacionDermatologo != null &&
                    info.recomendacionDermatologo!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B5EA7).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.medical_services_outlined,
                          size: 20,
                          color: Color(0xFF7B5EA7),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            info.recomendacionDermatologo!,
                            style: const TextStyle(
                              color: Color(0xFF444444),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (info.consejosCuidado.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Consejos de cuidado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...info.consejosCuidado.map(
                    (consejo) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Color(0xFF7B5EA7),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              consejo,
                              style: const TextStyle(
                                color: Color(0xFF555555),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            Text(
              estado.descripcion.isNotEmpty
                  ? estado.descripcion
                  : 'La ${estado.condicion.displayName.toLowerCase()} es una afección de la piel. Se recomienda seguir una rutina adecuada y consultar a un profesional si los síntomas persisten.',
              style: const TextStyle(
                color: Color(0xFF555555),
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _seccionResultados(DiagnosticoEstado estado) {
    final detecciones = estado.deteccionesResumen;
    final severidadText = estado.severidad;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.smart_toy_outlined,
                color: ColoresApp.primario,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Resultados del análisis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          if (severidadText.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: ColoresApp.primario,
                ),
                const SizedBox(width: 8),
                Text(
                  'Severidad: ${severidadText.toUpperCase()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
              ],
            ),
          ],

          if (detecciones.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...detecciones.entries.map(
              (entrada) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: ColoresApp.primario,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${entrada.key}: ${entrada.value}',
                        style: TextStyle(
                          color: ColoresApp.textoSecundario,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

          Text(
            estado.descripcion.isNotEmpty
                ? estado.descripcion
                : 'Análisis completado. No se detectaron condiciones significativas.',
            style: TextStyle(
              color: ColoresApp.textoSecundario,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}