import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';

class CargaPantalla extends StatefulWidget {
  const CargaPantalla({super.key});

  @override
  State<CargaPantalla> createState() =>
      _CargaPantallaState();
}

class _CargaPantallaState
    extends State<CargaPantalla> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {

        Get.offNamed(
          AppRutas.bienvenida,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColoresApp.primario,

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Container(
              width: 120,
              height: 120,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                      30,
                    ),
              ),

              child: Icon(
                Icons.spa_outlined,

                size: 60,

                color:
                    ColoresApp.primario,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'SkinGPT',

              style: TextStyle(
                color: Colors.white,

                fontSize: 34,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'IA dermatológica inteligente',

              style: TextStyle(
                color: Colors.white
                    .withOpacity(.85),

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            const SizedBox(
              width: 34,
              height: 34,

              child:
                  CircularProgressIndicator(
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