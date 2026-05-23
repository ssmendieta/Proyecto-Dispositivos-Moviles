import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ImagenUtil {
  static const int tamanioDefecto = 224;

  static Future<Uint8List> _decodificarRedimensionar(
    File imagen, {
    int size = tamanioDefecto,
  }) async {
    final bytes = await imagen.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes,
        targetWidth: size, targetHeight: size);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    return byteData!.buffer.asUint8List();
  }

  static List<List<List<List<double>>>> normalizar(
    Uint8List pixels, {
    int size = tamanioDefecto,
  }) {
    final batch = List.generate(
      1,
      (_) => List.generate(
        size,
        (_) => List.generate(size, (_) => List.filled(3, 0.0)),
      ),
    );

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final idx = (y * size + x) * 4;
        batch[0][y][x][0] = pixels[idx] / 255.0;
        batch[0][y][x][1] = pixels[idx + 1] / 255.0;
        batch[0][y][x][2] = pixels[idx + 2] / 255.0;
      }
    }

    return batch;
  }

  static Future<List<List<List<List<double>>>>> preprocesar(
    File imagen, {
    int size = tamanioDefecto,
  }) async {
    final pixels = await _decodificarRedimensionar(imagen, size: size);
    return normalizar(pixels, size: size);
  }
}
