import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../controladores/login_controlador.dart';

class LoginPantalla extends GetView<LoginControlador> {
  const LoginPantalla({super.key});

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
                  Row(
                    children: [
                      Icon(
                        Icons.health_and_safety,
                        color: ColoresApp.primario,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'SkinGPT',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColoresApp.primario,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: Color(0xFFE6F7FA),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFF006B93),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Inicia sesión para continuar con tu cuidado de la piel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      fontSize: 15,
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
                        _label('Correo electrónico'),

                        _campo(
                          controller: controller.correoController,
                          hint: 'correo@ejemplo.com',
                          icono: Icons.alternate_email,
                        ),

                        const SizedBox(height: 18),

                        _buildPasswordField(),

                        const SizedBox(height: 14),

                        _buildRememberMe(),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () => controller.iniciarSesion(),
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Iniciar sesión'),
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  TextButton(
                    onPressed: controller.irARegistro,
                    child: Text.rich(
                      TextSpan(
                        text: '¿No tienes una cuenta? ',
                        style: TextStyle(
                          color: ColoresApp.textoPrincipal,
                        ),
                        children: [
                          TextSpan(
                            text: 'Crear cuenta',
                            style: TextStyle(
                              color: ColoresApp.primario,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    'Política de Privacidad • Términos de Servicio • Ayuda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '© 2024 SkinGPT. Asistencia dermatológica inteligente.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario.withValues(alpha: 0.6),
                      fontSize: 12,
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

  Widget _buildPasswordField() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label('Contraseña'),
              Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: ColoresApp.primario,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
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

  Widget _buildRememberMe() {
    return Obx(
      () => Row(
        children: [
          Checkbox(
            value: controller.recordarSesion.value,
            onChanged: (valor) {
              controller.recordarSesion.value = valor ?? false;
            },
          ),
          InkWell(
            onTap: () {
              controller.recordarSesion.value = !controller.recordarSesion.value;
            },
            child: Text(
              'Mantener sesión iniciada',
              style: TextStyle(
                color: ColoresApp.textoSecundario,
              ),
            ),
          ),
        ],
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