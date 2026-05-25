import 'package:get/get.dart';

class RutinasControlador extends GetxController {
  final filtroSeleccionado = 'Todas'.obs;

  final rutinaManana = <Map<String, dynamic>>[].obs;
  final rutinaNoche = <Map<String, dynamic>>[].obs;

  void cambiarFiltro(String filtro) {
    filtroSeleccionado.value = filtro;
  }

  void agregarProducto({
    required String nombre,
    required String marca,
    required bool manana,
    required bool noche,
  }) {
    final producto = {
      'nombre': nombre,
      'marca': marca,
      'completado': false,
    };

    if (manana) {
      rutinaManana.add(Map<String, dynamic>.from(producto));
    }

    if (noche) {
      rutinaNoche.add(Map<String, dynamic>.from(producto));
    }
  }

  void toggleManana(int index) {
    rutinaManana[index]['completado'] =
        !rutinaManana[index]['completado'];
    rutinaManana.refresh();
  }

  void toggleNoche(int index) {
    rutinaNoche[index]['completado'] =
        !rutinaNoche[index]['completado'];
    rutinaNoche.refresh();
  }
}