import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';

class LoginPantalla extends StatelessWidget {
  LoginPantalla({super.key});

  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  final verPassword = false.obs;
  final recordarSesion = false.obs;

  void _validarLogin() {
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Campos incompletos',
        'Por favor ingresa tu correo y contraseña.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!correo.contains('@')) {
      Get.snackbar(
        'Correo inválido',
        'Ingresa un correo electrónico válido.',
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
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Sign in to continue your personalized skin journey.',
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
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Username or Email'),

                          _campo(
                            controller: correoController,
                            hint: 'name@example.com',
                            icono: Icons.alternate_email,
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _label('Password'),
                              Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: ColoresApp.primario,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          _campo(
                            controller: passwordController,
                            hint: '••••••••',
                            icono: Icons.lock_outline,
                            obscure: !verPassword.value,
                            suffix: verPassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            onSuffixTap: () {
                              verPassword.value = !verPassword.value;
                            },
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Checkbox(
                                value: recordarSesion.value,
                                onChanged: (valor) {
                                  recordarSesion.value = valor ?? false;
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  recordarSesion.value =
                                      !recordarSesion.value;
                                },
                                child: Text(
                                  'Keep me logged in',
                                  style: TextStyle(
                                    color: ColoresApp.textoSecundario,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _validarLogin,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Log In'),
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
                  ),

                  const SizedBox(height: 28),

                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRutas.registro);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: ColoresApp.textoPrincipal,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign up for SkinGPT',
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
                    'Privacy Policy   •   Terms of Service   •   Help Center',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '© 2024 SkinGPT. Clinical Accuracy Guaranteed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColoresApp.textoSecundario.withOpacity(.6),
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