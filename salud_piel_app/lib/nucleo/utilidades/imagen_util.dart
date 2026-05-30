import 'dart:io';

import 'package:image/image.dart' as img;

class ImagenUtil {
  static img.Image cargarImagen(String imagePath) {
    final bytes = File(imagePath).readAsBytesSync();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('No se pudo leer la imagen seleccionada.');
    }

    return image;
  }

  static List<List<List<List<double>>>> prepararParaMobileNet({
    required String imagePath,
    required int size,
  }) {
    final original = cargarImagen(imagePath);

    final resized = img.copyResize(
      original,
      width: size,
      height: size,
    );

    return [
      List.generate(size, (y) {
        return List.generate(size, (x) {
          final pixel = resized.getPixel(x, y);

          final r = pixel.r.toDouble();
          final g = pixel.g.toDouble();
          final b = pixel.b.toDouble();

          return [r, g, b];
        });
      }),
    ];
  }

  static List<List<List<List<double>>>> prepararParaYolo({
    required String imagePath,
    required int size,
  }) {
    final original = cargarImagen(imagePath);

    final resized = img.copyResize(
      original,
      width: size,
      height: size,
    );

    return [
      List.generate(size, (y) {
        return List.generate(size, (x) {
          final pixel = resized.getPixel(x, y);

          final r = pixel.r.toDouble() / 255.0;
          final g = pixel.g.toDouble() / 255.0;
          final b = pixel.b.toDouble() / 255.0;

          return [r, g, b];
        });
      }),
    ];
  }
}