import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';
import '../controladores/auth_provider.dart';

class RegistroPantalla extends ConsumerStatefulWidget {
  const RegistroPantalla({super.key});

  @override
  ConsumerState<RegistroPantalla> createState() =>
      _RegistroPantallaState();
}

class _RegistroPantallaState extends ConsumerState<RegistroPantalla> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool verPassword = false;
  bool verConfirmPassword = false;

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String titulo, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$titulo\n$mensaje'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _registrar() async {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (nombre.isEmpty ||
        correo.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _mostrarMensaje(
        'Campos incompletos',
        'Completa todos los campos.',
      );
      return;
    }

    if (!correo.contains('@')) {
      _mostrarMensaje(
        'Correo inválido',
        'Ingresa un correo válido.',
      );
      return;
    }

    if (password.length < 6) {
      _mostrarMensaje(
        'Contraseña débil',
        'La contraseña debe tener mínimo 6 caracteres.',
      );
      return;
    }

    if (password != confirmPassword) {
      _mostrarMensaje(
        'Contraseñas diferentes',
        'Las contraseñas no coinciden.',
      );
      return;
    }

    final error = await ref.read(sesionProvider.notifier).registrar(
          nombre,
          correo,
          password,
        );

    if (!mounted) return;

    if (error != null) {
      _mostrarMensaje(
        'Error',
        error,
      );
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRutas.informacionPersonal,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cargando = ref.watch(
      sesionProvider.select((estado) => estado.cargando),
    );

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
                          controller: nombreController,
                          hint: 'Ej. Juan Pérez',
                          icono: Icons.person_outline,
                        ),

                        const SizedBox(height: 16),

                        _label('Correo electrónico'),

                        _campo(
                          controller: correoController,
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
                            onPressed: cargando ? null : _registrar,
                            icon: cargando
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.arrow_forward),
                            label: Text(
                              cargando ? 'Creando cuenta...' : 'Crear cuenta',
                            ),
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
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRutas.login,
                              );
                            },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Contraseña'),
        _campo(
          controller: passwordController,
          hint: '••••••••',
          icono: Icons.lock_outline,
          obscure: !verPassword,
          suffix: verPassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: () {
            setState(() {
              verPassword = !verPassword;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRegConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Confirmar contraseña'),
        _campo(
          controller: confirmPasswordController,
          hint: '••••••••',
          icono: Icons.shield_outlined,
          obscure: !verConfirmPassword,
          suffix: verConfirmPassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: () {
            setState(() {
              verConfirmPassword = !verConfirmPassword;
            });
          },
        ),
      ],
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
          borderSide: BorderSide(
            color: ColoresApp.borde,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColoresApp.borde,
          ),
        ),
      ),
    );
  }
}