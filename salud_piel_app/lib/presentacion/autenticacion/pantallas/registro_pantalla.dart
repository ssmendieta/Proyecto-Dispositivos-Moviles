import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../controladores/registro_controlador.dart';

class RegistroPantalla extends GetView<RegistroControlador> {
  const RegistroPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: ColoresApp.primario,
                      borderRadius: BorderRadius.circular(18),
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
                    'Crea tu cuenta para recibir recomendaciones personalizadas para tu piel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      fontSize: 15,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Crear cuenta',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColoresApp.textoPrincipal,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        _label('Nombre completo'),

                        _campo(
                          controller: controller.nombreController,
                          hint: 'Ej. Juan Pérez',
                          icono: Icons.person_outline,
                        ),

                        const SizedBox(height: 16),

                        _label('Correo electrónico'),

                        _campo(
                          controller: controller.correoController,
                          hint: 'usuario@ejemplo.com',
                          icono: Icons.email_outlined,
                        ),

                        const SizedBox(height: 16),

                        _buildRegPasswordField(),

                        const SizedBox(height: 16),

                        _buildRegConfirmPasswordField(),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () => controller.registrar(),
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Crear cuenta'),
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

                        const SizedBox(height: 22),

                        Divider(color: Colors.grey.shade300),

                        const SizedBox(height: 16),

                        Center(
                          child: TextButton(
                            onPressed: controller.irALogin,
                            child: Text.rich(
                              TextSpan(
                                text: '¿Ya tienes una cuenta? ',
                                style: TextStyle(
                                  color: ColoresApp.textoPrincipal,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Iniciar sesión',
                                    style: TextStyle(
                                      color: ColoresApp.primario,
                                      fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegPasswordField() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Contraseña'),
          _campo(
            controller: controller.passwordController,
            hint: '••••••••',
            icono: Icons.lock_outline,
            obscure: !controller.verPassword.value,
            suffix: controller.verPassword.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: () {
              controller.verPassword.value = !controller.verPassword.value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegConfirmPasswordField() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Confirmar contraseña'),
          _campo(
            controller: controller.confirmPasswordController,
            hint: '••••••••',
            icono: Icons.shield_outlined,
            obscure: !controller.verConfirmPassword.value,
            suffix: controller.verConfirmPassword.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: () {
              controller.verConfirmPassword.value =
                  !controller.verConfirmPassword.value;
            },
          ),
        ],
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