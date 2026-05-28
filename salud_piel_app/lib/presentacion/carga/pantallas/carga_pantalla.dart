import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../controladores/carga_controlador.dart';

class CargaPantalla extends GetView<CargaControlador> {
  const CargaPantalla({super.key});

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
