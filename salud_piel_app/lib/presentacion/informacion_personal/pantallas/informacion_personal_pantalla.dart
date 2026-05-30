import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../controladores/informacion_personal_controlador.dart';

class InformacionPersonalPantalla
    extends GetView<InformacionPersonalControlador> {
  const InformacionPersonalPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                children: [
                  Icon(
                    Icons.assignment_ind_outlined,
                    size: 64,
                    color: ColoresApp.primario,
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Información personal',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Estos datos ayudarán a crear una rutina más adecuada para tu piel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Edad'),
                          _campo(
                            controller: controller.edadController,
                            hint: 'Ej. 22',
                            icono: Icons.cake_outlined,
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 16),

                          _label('Tipo de piel'),
                          DropdownButtonFormField<String>(
                            value: controller.tipoPiel.value,
                            items: controller.tiposPiel
                                .map(
                                  (tipo) => DropdownMenuItem(
                                    value: tipo,
                                    child: Text(tipo),
                                  ),
                                )
                                .toList(),
                            onChanged: (valor) {
                              if (valor != null) {
                                controller.cambiarTipoPiel(valor);
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.face_retouching_natural),
                              filled: true,
                              fillColor: ColoresApp.fondo,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: ColoresApp.borde),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: ColoresApp.borde),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          _label('Hora aproximada de dormir'),
                          _campo(
                            controller: controller.horaDormirController,
                            hint: 'Ej. 23:00',
                            icono: Icons.nightlight_round,
                          ),

                          const SizedBox(height: 16),

                          _label('Alergias o sensibilidad'),
                          _campo(
                            controller: controller.alergiasController,
                            hint: 'Ej. fragancias, alcohol, ninguno',
                            icono: Icons.warning_amber_outlined,
                          ),

                          const SizedBox(height: 26),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: controller.continuar,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Continuar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColoresApp.primario,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String hint,
    required IconData icono,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icono),
        filled: true,
        fillColor: ColoresApp.fondo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColoresApp.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColoresApp.borde),
        ),
      ),
    );
  }
}