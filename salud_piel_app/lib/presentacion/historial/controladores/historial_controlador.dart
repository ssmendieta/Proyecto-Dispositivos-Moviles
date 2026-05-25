import 'package:get/get.dart';

class HistorialControlador extends GetxController {

  final analisis = <Map<String, String>>[

    {
      'titulo': 'Nevo Melanocítico',
      'fecha': '12 Oct 2023',
      'estado': 'ATENCIÓN',
      'porcentaje': '92%',
    },

    {
      'titulo': 'Dermatitis Atópica',
      'fecha': '05 Oct 2023',
      'estado': 'ESTABLE',
      'porcentaje': '87%',
    },

    {
      'titulo': 'Queritosis Seborreica',
      'fecha': '28 Sep 2023',
      'estado': 'SEGUIMIENTO',
      'porcentaje': '95%',
    },

  ].obs;

  void agregarAnalisis({
    required String titulo,
    required String fecha,
    required String estado,
    required String porcentaje,
  }) {

    analisis.insert(0, {
      'titulo': titulo,
      'fecha': fecha,
      'estado': estado,
      'porcentaje': porcentaje,
    });
  }
}