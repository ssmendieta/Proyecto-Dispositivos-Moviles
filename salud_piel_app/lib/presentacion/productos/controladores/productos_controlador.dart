import 'package:get/get.dart';

class ProductosControlador extends GetxController {
  final busqueda = ''.obs;
  final categoriaSeleccionada = 'Todos'.obs;

  final categorias = [
    'Todos',
    'Limpiadores',
    'Sérums',
    'Cremas',
    'Protector solar',
  ];

  final productos = <Map<String, String>>[
    {
      'nombre': 'CeraVe Hydrating Cleanser',
      'marca': 'CeraVe',
      'categoria': 'Limpiadores',
      'compatibilidad': '96%',
    },
    {
      'nombre': 'Niacinamide 10%',
      'marca': 'The Ordinary',
      'categoria': 'Sérums',
      'compatibilidad': '91%',
    },
    {
      'nombre': 'Toleriane Sensitive',
      'marca': 'La Roche-Posay',
      'categoria': 'Cremas',
      'compatibilidad': '94%',
    },
    {
      'nombre': 'Anthelios SPF 50',
      'marca': 'La Roche-Posay',
      'categoria': 'Protector solar',
      'compatibilidad': '98%',
    },
    {
      'nombre': 'Moisturizing Cream',
      'marca': 'CeraVe',
      'categoria': 'Cremas',
      'compatibilidad': '95%',
    },
    {
      'nombre': 'Hyaluronic Acid Serum',
      'marca': 'The Ordinary',
      'categoria': 'Sérums',
      'compatibilidad': '93%',
    },
  ].obs;

  void cambiarCategoria(String categoria) {
    categoriaSeleccionada.value = categoria;
  }

  void cambiarBusqueda(String texto) {
    busqueda.value = texto;
  }
}