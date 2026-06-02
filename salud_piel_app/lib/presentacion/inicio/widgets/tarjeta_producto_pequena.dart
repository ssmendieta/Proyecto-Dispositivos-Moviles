import 'package:flutter/material.dart';

import '../../compartidos/widget/imagen_producto.dart';
import '../../constantes/colores.dart';

class TarjetaProductoPequena extends StatelessWidget {
  final String nombre;
  final String marca;
  final String? imagenPath;

  const TarjetaProductoPequena({
    super.key,
    required this.nombre,
    required this.marca,
    this.imagenPath,
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
          SizedBox(
            height: 120,
            child: ImagenProducto(
              imagenPath: imagenPath,
              borderRadius: 14,
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
