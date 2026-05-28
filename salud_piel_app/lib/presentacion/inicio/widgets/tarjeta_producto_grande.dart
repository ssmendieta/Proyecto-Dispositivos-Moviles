import 'package:flutter/material.dart';

import '../../constantes/colores.dart';

class TarjetaProductoGrande extends StatelessWidget {
  final String nombre;
  final String marca;

  const TarjetaProductoGrande({
    super.key,
    required this.nombre,
    required this.marca,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: const Color(0xFF071A25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.water_drop_outlined,
                color: Colors.white,
                size: 70,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nombre,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            marca,
            style: TextStyle(
              fontSize: 12,
              color: ColoresApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Listo'),
            ),
          ),
        ],
      ),
    );
  }
}
