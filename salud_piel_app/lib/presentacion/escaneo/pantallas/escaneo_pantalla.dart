import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../datos/servicios/ml_servicio.dart';
import '../../constantes/colores.dart';
import '../../inicio/controladores/inicio_provider.dart';
import '../../rutas/app_rutas.dart';
import '../controladores/escaneo_provider.dart';

class EscaneoPantalla extends ConsumerStatefulWidget {
  const EscaneoPantalla({super.key});

  @override
  ConsumerState<EscaneoPantalla> createState() => _EscaneoPantallaState();
}

class _EscaneoPantallaState extends ConsumerState<EscaneoPantalla> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(escaneoProvider.notifier).iniciarCamara();
    });
  }

  void _volverInicio() {
    ref.read(indiceActualProvider.notifier).state = 0;
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _irADiagnostico(ResultadoAnalisis resultado) {
    Navigator.pushNamed(
      context,
      AppRutas.diagnostico,
      arguments: resultado,
    );
  }

  Future<void> _tomarFoto() async {
    final resultado = await ref.read(escaneoProvider.notifier).tomarFoto();

    if (!mounted) {
      return;
    }

    if (resultado != null) {
      _irADiagnostico(resultado);
      return;
    }

    final error = ref.read(escaneoProvider).error;
    if (error != null) {
      _mostrarError(error);
    }
  }

  Future<void> _seleccionarDeGaleria() async {
    final resultado =
        await ref.read(escaneoProvider.notifier).seleccionarDeGaleria();

    if (!mounted) {
      return;
    }

    if (resultado != null) {
      _irADiagnostico(resultado);
      return;
    }

    final error = ref.read(escaneoProvider).error;
    if (error != null) {
      _mostrarError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(escaneoProvider);
    final notifier = ref.read(escaneoProvider.notifier);
    final cameraController = notifier.cameraController;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Builder(
        builder: (context) {
          if (estado.inicializando) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (estado.camaraDisponible &&
              cameraController != null &&
              cameraController.value.isInitialized) {
            return _buildCameraView(
              cameraController: cameraController,
              estado: estado,
            );
          }

          return _buildFallback(
            estado: estado,
          );
        },
      ),
    );
  }

  Widget _buildCameraView({
    required CameraController cameraController,
    required EscaneoEstado estado,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: cameraController.buildPreview(),
        ),

        Container(
          color: Colors.black.withValues(alpha: 0.2),
        ),

        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: estado.analizando ? null : _volverInicio,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Text(
                'SkinGPT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColoresApp.acento,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Iluminación óptima',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        Center(
          child: Container(
            width: 290,
            height: 390,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(160),
            ),
            child: Center(
              child: Text(
                'CENTRA TU ROSTRO',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 210,
          left: 70,
          child: _esquina(),
        ),
        Positioned(
          top: 210,
          right: 70,
          child: Transform.rotate(
            angle: 1.5708,
            child: _esquina(),
          ),
        ),
        Positioned(
          bottom: 190,
          left: 70,
          child: Transform.rotate(
            angle: -1.5708,
            child: _esquina(),
          ),
        ),
        Positioned(
          bottom: 190,
          right: 70,
          child: Transform.rotate(
            angle: 3.1416,
            child: _esquina(),
          ),
        ),

        Positioned(
          left: 30,
          right: 30,
          bottom: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: estado.analizando ? null : _seleccionarDeGaleria,
                child: _accionInferior(
                  icono: Icons.photo_library_outlined,
                  texto: 'Galería',
                ),
              ),
              GestureDetector(
                onTap: estado.analizando ? null : _tomarFoto,
                child: Container(
                  width: 84,
                  height: 84,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              _accionInferior(
                icono: Icons.flash_on,
                texto: 'Flash',
              ),
            ],
          ),
        ),

        if (estado.analizando)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.55),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Analizando imagen...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFallback({
    required EscaneoEstado estado,
  }) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF0A0A0A),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: estado.analizando ? null : _volverInicio,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Text(
                'SkinGPT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 80),
            ],
          ),
        ),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.videocam_off,
                color: Colors.white54,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Cámara no disponible',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: estado.analizando ? null : _seleccionarDeGaleria,
                icon: estado.analizando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.photo_library_outlined),
                label: Text(
                  estado.analizando
                      ? 'Analizando...'
                      : 'Seleccionar de Galería',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.primario,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _esquina() {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ColoresApp.acento,
            width: 3,
          ),
          left: BorderSide(
            color: ColoresApp.acento,
            width: 3,
          ),
        ),
      ),
    );
  }

  Widget _accionInferior({
    required IconData icono,
    required String texto,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icono,
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}