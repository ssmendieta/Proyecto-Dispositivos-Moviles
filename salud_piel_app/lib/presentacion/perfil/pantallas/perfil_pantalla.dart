import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../historial/pantallas/historial_pantalla.dart';

class PerfilPantalla extends StatelessWidget {
  const PerfilPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFFE6D5F7),
              child: Icon(
                Icons.person,
                size: 64,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Gemina Ponce',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ColoresApp.textoPrincipal,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Piel grasa • Sensible',
              style: TextStyle(
                color: ColoresApp.textoSecundario,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    icono: Icons.camera_alt_outlined,
                    titulo: 'Total scans',
                    valor: '24',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _infoCard(
                    icono: Icons.favorite,
                    titulo: 'Health score',
                    valor: '88/100',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _opcionPerfil(
              icono: Icons.history,
              texto: 'Ver Historial',
              onTap: () {
                Get.to(() => const HistorialPantalla());
              },
            ),

            const SizedBox(height: 12),

            _opcionPerfil(
              icono: Icons.logout,
              texto: 'Logout',
              color: ColoresApp.peligro,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icono,
            color: ColoresApp.primario,
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            titulo.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: ColoresApp.textoSecundario,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColoresApp.textoPrincipal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcionPerfil({
    required IconData icono,
    required String texto,
    required VoidCallback onTap,
    Color? color,
  }) {
    final colorFinal = color ?? ColoresApp.textoPrincipal;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color ?? Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icono, color: colorFinal),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  color: colorFinal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: colorFinal),
          ],
        ),
      ),
    );
  }
}