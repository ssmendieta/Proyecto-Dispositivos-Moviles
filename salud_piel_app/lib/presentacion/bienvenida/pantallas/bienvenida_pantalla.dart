import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../controladores/bienvenida_controlador.dart';

class BienvenidaPantalla
    extends GetView<BienvenidaControlador> {

  const BienvenidaPantalla({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColoresApp.fondo,

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [

              const Spacer(),

              Container(
                width: 170,
                height: 170,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                        40,
                      ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.05),

                      blurRadius: 20,

                      offset: const Offset(
                        0,
                        10,
                      ),
                    ),
                  ],
                ),

                child: Icon(
                  Icons.spa_outlined,

                  size: 90,

                  color:
                      ColoresApp.primario,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'SkinGPT',

                style: TextStyle(
                  fontSize: 38,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      ColoresApp
                          .textoPrincipal,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Tu asistente inteligente\npara el cuidado de la piel.',

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 18,

                  height: 1.5,

                  color:
                      ColoresApp
                          .textoSecundario,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: controller.irALogin,

                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                            ColoresApp
                                .primario,

                        shape:
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),
                            ),
                      ),

                  child: const Text(
                    'Iniciar Sesión',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 17,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: OutlinedButton(
                  onPressed: controller.irARegistro,

                  style:
                      OutlinedButton.styleFrom(
                        side: BorderSide(
                          color:
                              ColoresApp
                                  .primario,
                        ),

                        shape:
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),
                            ),
                      ),

                  child: Text(
                    'Crear Cuenta',

                    style: TextStyle(
                      color:
                          ColoresApp
                              .primario,

                      fontSize: 17,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}