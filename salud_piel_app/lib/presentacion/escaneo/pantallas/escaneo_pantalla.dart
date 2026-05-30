import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';
import '../../inicio/controladores/inicio_controlador.dart';
import '../controladores/escaneo_controlador.dart';

class EscaneoPantalla extends StatefulWidget {
  const EscaneoPantalla({super.key});

  @override
  State<EscaneoPantalla> createState() => _EscaneoPantallaState();
}

class _EscaneoPantallaState extends State<EscaneoPantalla> {
  late final InicioControlador inicioControlador;
  late final EscaneoControlador escaneoControlador;
  bool _analisisEnCurso = false;

  @override
  void initState() {
    super.initState();
    inicioControlador = Get.find<InicioControlador>();
    escaneoControlador = Get.find<EscaneoControlador>();
  }

  Future<void> _ejecutarAnalisis(Future<void> Function() accion) async {
    if (_analisisEnCurso || escaneoControlador.cargando) return;

    _analisisEnCurso = true;
    try {
      await accion();

      if (!mounted) return;

      if (escaneoControlador.resultado != null) {
        await Get.toNamed(
          AppRutas.diagnostico,
          arguments: escaneoControlador.resultado,
        );
      } else if (escaneoControlador.mensajeError != null) {
        Get.snackbar(
          'No se pudo analizar',
          escaneoControlador.mensajeError!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.85),
          colorText: Colors.white,
        );
      }
    } finally {
      _analisisEnCurso = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: escaneoControlador,
      builder: (context, _) {
        return Stack(
          children: [
            Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Stack(
          children: [
            /// Fondo cámara
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

            /// HEADER
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      inicioControlador.cambiarPagina(0);
                    },
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

            /// GUÍA ROSTRO
            Center(
              child: Container(
                width: 290,
                height: 390,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(.6),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(160),
                ),
                child: Center(
                  child: Text(
                    'CENTRA TU ROSTRO',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.85),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),

            /// ESQUINAS
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

            /// CONTROLES
            Positioned(
              left: 30,
              right: 30,
              bottom: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// GALERÍA
                  GestureDetector(
                    onTap: () => _ejecutarAnalisis(
                      () => escaneoControlador.analizarDesdeGaleria(),
                    ),
                    child: _accionInferior(
                      icono: Icons.photo_library_outlined,
                      texto: 'Galería',
                    ),
                  ),

                  /// BOTÓN CÁMARA
                  GestureDetector(
                    onTap: () => _ejecutarAnalisis(
                      () => escaneoControlador.analizarDesdeCamara(),
                    ),
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

                  /// FLASH VISUAL
                  _accionInferior(
                    icono: Icons.flash_on,
                    texto: 'Flash',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
            ),
            if (escaneoControlador.cargando)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.65),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Analizando imagen...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
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