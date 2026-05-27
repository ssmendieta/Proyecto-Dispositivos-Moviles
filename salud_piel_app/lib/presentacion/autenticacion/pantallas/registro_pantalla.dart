import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';

class RegistroPantalla extends StatelessWidget {
  RegistroPantalla({super.key});

  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final verPassword = false.obs;
  final verConfirmPassword = false.obs;

  void _validarRegistro() {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword =
        confirmPasswordController.text.trim();

    if (nombre.isEmpty ||
        correo.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Campos incompletos',
        'Completa todos los campos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!correo.contains('@')) {
      Get.snackbar(
        'Correo inválido',
        'Ingresa un correo válido.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Contraseña débil',
        'La contraseña debe tener mínimo 6 caracteres.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Contraseñas diferentes',
        'Las contraseñas no coinciden.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.offAllNamed(AppRutas.inicio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 520,
              ),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: ColoresApp.primario,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.biotech,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'SkinGPT',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.primario,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Tu asistente inteligente para el cuidado clínico de la piel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          ColoresApp.textoSecundario,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(.06),
                            blurRadius: 20,
                            offset: const Offset(
                              0,
                              10,
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Crear Cuenta',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                                color: ColoresApp
                                    .textoPrincipal,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          _label('Nombre Completo'),

                          _campo(
                            controller:
                                nombreController,
                            hint: 'Ej. Juan Pérez',
                            icono:
                                Icons.person_outline,
                          ),

                          const SizedBox(height: 16),

                          _label(
                            'Correo electrónico',
                          ),

                          _campo(
                            controller:
                                correoController,
                            hint:
                                'usuario@ejemplo.com',
                            icono:
                                Icons.email_outlined,
                          ),

                          const SizedBox(height: 16),

                          _label('Contraseña'),

                          _campo(
                            controller:
                                passwordController,
                            hint: '••••••••',
                            icono:
                                Icons.lock_outline,
                            obscure:
                                !verPassword.value,
                            suffix:
                                verPassword.value
                                    ? Icons
                                        .visibility_off_outlined
                                    : Icons
                                        .visibility_outlined,
                            onSuffixTap: () {
                              verPassword.value =
                                  !verPassword.value;
                            },
                          ),

                          const SizedBox(height: 16),

                          _label(
                            'Confirmar Contraseña',
                          ),

                          _campo(
                            controller:
                                confirmPasswordController,
                            hint: '••••••••',
                            icono:
                                Icons.shield_outlined,
                            obscure:
                                !verConfirmPassword
                                    .value,
                            suffix:
                                verConfirmPassword
                                        .value
                                    ? Icons
                                        .visibility_off_outlined
                                    : Icons
                                        .visibility_outlined,
                            onSuffixTap: () {
                              verConfirmPassword
                                      .value =
                                  !verConfirmPassword
                                      .value;
                            },
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child:
                                ElevatedButton.icon(
                              onPressed:
                                  _validarRegistro,
                              icon: const Icon(
                                Icons.arrow_forward,
                              ),
                              label: const Text(
                                'Crear Cuenta',
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColoresApp
                                        .primario,
                                foregroundColor:
                                    Colors.white,
                                textStyle:
                                    const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    14,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          Divider(
                            color:
                                Colors.grey.shade300,
                          ),

                          const SizedBox(height: 16),

                          Center(
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(
                                  AppRutas.login,
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      '¿Ya tienes una cuenta? ',
                                  style: TextStyle(
                                    color: ColoresApp
                                        .textoPrincipal,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          'Iniciar Sesión',
                                      style:
                                          TextStyle(
                                        color:
                                            ColoresApp
                                                .primario,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
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
    bool obscure = false,
    IconData? suffix,
    VoidCallback? onSuffixTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icono),
        suffixIcon: suffix == null
            ? null
            : IconButton(
                onPressed: onSuffixTap,
                icon: Icon(suffix),
              ),
        filled: true,
        fillColor: ColoresApp.fondo,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColoresApp.borde,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColoresApp.borde,
          ),
        ),
      ),
    );
  }
}