import 'package:flutter/material.dart';

import '../../constantes/colores.dart';

class TarjetaProductoPequena extends StatelessWidget {
  final String nombre;
  final String marca;

  const TarjetaProductoPequena({
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
            height: 120,
            decoration: BoxDecoration(
              color: ColoresApp.fondo,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Icons.spa_outlined, size: 42),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            nombre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColoresApp.textoPrincipal,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            marca,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: ColoresApp.textoSecundario,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 34,
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
