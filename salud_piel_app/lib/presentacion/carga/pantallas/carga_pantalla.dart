import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../autenticacion/controladores/auth_provider.dart';
import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';

class CargaPantalla extends ConsumerStatefulWidget {
  const CargaPantalla({super.key});

  @override
  ConsumerState<CargaPantalla> createState() => _CargaPantallaState();
}

class _CargaPantallaState extends ConsumerState<CargaPantalla> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _iniciar();
    });
  }

  Future<void> _iniciar() async {
    await Future.delayed(const Duration(seconds: 2));

    await ref.read(sesionProvider.notifier).verificarSesion();

    if (!mounted) return;

    final sesion = ref.read(sesionProvider);

    if (sesion.sesionIniciada) {
      Navigator.pushReplacementNamed(
        context,
        AppRutas.inicio,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRutas.bienvenida,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.primario,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.spa_outlined,
                size: 60,
                color: ColoresApp.primario,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'SkinGPT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'IA dermatológica inteligente',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            const SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}