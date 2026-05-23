import 'dart:io';
import 'package:get/get.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';

class MlServicio extends GetxService {
  final modeloCargado = false.obs;

  Future<MlServicio> init() async {
    modeloCargado.value = false;
    return this;
  }

  Future<(CondicionPiel, double)> clasificar(File imagen) async {
    await Future.delayed(const Duration(seconds: 1));
    return (CondicionPiel.normal, 0.0);
  }
}
