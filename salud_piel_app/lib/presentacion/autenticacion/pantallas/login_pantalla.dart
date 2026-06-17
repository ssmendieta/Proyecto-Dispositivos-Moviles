import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constantes/colores.dart';
import '../../rutas/app_rutas.dart';
import '../controladores/auth_provider.dart';

class LoginPantalla extends ConsumerStatefulWidget {
  const LoginPantalla({super.key});

  @override
  ConsumerState<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends ConsumerState<LoginPantalla> {
  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  bool verPassword = false;
  bool recordarSesion = false;

  @override
  void dispose() {
    correoController.dispose();
    passwordController.dispose();
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

  Future<void> _iniciarSesion() async {
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      _mostrarMensaje(
        'Campos incompletos',
        'Ingresa tu correo y contraseña.',
      );
      return;
    }

    if (!correo.contains('@')) {
      _mostrarMensaje(
        'Correo inválido',
        'Ingresa un correo electrónico válido.',
      );
      return;
    }

    final error = await ref.read(sesionProvider.notifier).login(
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
      AppRutas.inicio,
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
                          controller: correoController,
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
                            onPressed: cargando ? null : _iniciarSesion,
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
                              cargando ? 'Ingresando...' : 'Iniciar sesión',
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRutas.registro,
                      );
                    },
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
                      color: ColoresApp.textoSecundario.withValues(
                        alpha: 0.6,
                      ),
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
    return Column(
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

  Widget _buildRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: recordarSesion,
          onChanged: (valor) {
            setState(() {
              recordarSesion = valor ?? false;
            });
          },
        ),
        InkWell(
          onTap: () {
            setState(() {
              recordarSesion = !recordarSesion;
            });
          },
          child: Text(
            'Mantener sesión iniciada',
            style: TextStyle(
              color: ColoresApp.textoSecundario,
            ),
          ),
        ),
      ],
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