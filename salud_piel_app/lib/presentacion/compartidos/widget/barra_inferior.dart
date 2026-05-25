import 'package:flutter/material.dart';
import '../../constantes/colores.dart';

class BarraInferior extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int> alCambiar;

  const BarraInferior({
    super.key,
    required this.indiceActual,
    required this.alCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceActual,
      onTap: alCambiar,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ColoresApp.acento,
      unselectedItemColor: ColoresApp.textoSecundario,
      backgroundColor: Colors.white,
      elevation: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_graph_outlined),
          activeIcon: Icon(Icons.auto_graph),
          label: 'Journey',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.center_focus_strong_outlined),
          activeIcon: Icon(Icons.center_focus_strong),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: 'Productos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}