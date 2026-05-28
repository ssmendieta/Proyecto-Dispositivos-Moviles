import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../inicio/controladores/inicio_controlador.dart';
import '../../rutas/app_rutas.dart';

class EscaneoControlador extends GetxController {
  final InicioControlador inicioControlador;
  CameraController? cameraController;

  EscaneoControlador({required this.inicioControlador});
  final inicializando = true.obs;
  final camaraDisponible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        camaraDisponible.value = false;
        inicializando.value = false;
        return;
      }
      camaraDisponible.value = true;
      final controller = CameraController(cameras.first, ResolutionPreset.high);
      cameraController = controller;
      await controller.initialize();
      inicializando.value = false;
    } catch (_) {
      camaraDisponible.value = false;
      inicializando.value = false;
    }
  }

  Future<void> tomarFoto() async {
    final cam = cameraController;
    if (cam == null || !cam.value.isInitialized) return;
    try {
      final XFile foto = await cam.takePicture();
      Get.toNamed(AppRutas.diagnostico, arguments: foto.path);
    } catch (_) {
      Get.snackbar('Error', 'No se pudo tomar la foto.');
    }
  }

  Future<void> seleccionarDeGaleria() async {
    try {
      final XFile? imagen = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagen != null) {
        Get.toNamed(AppRutas.diagnostico, arguments: imagen.path);
      }
    } catch (_) {
      Get.snackbar('Error', 'No se pudo acceder a la galería.');
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
