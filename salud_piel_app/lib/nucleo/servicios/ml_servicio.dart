import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Carga 3 modelos:
/// 1) skin_type_classifier.tflite -> clasifica tipo de piel
/// 2) acne_yolov8n.tflite -> detecta acné
/// 3) skin_conditions_yolov8n.tflite -> detecta condiciones: poros, puntos negros, rojeces, etc.

/// Este archivo asume que tienes estos assets:
/// assets/modelos/skin_type_classifier.tflite
/// assets/modelos/skin_type_labels.txt
/// assets/modelos/acne_yolov8n.tflite
/// assets/modelos/acne_labels.txt
/// assets/modelos/skin_conditions_yolov8n.tflite
/// assets/modelos/skin_conditions_labels.txt
class MlServicio {
  static final MlServicio _instancia = MlServicio._interno();
  factory MlServicio() => _instancia;
  MlServicio._interno();

  static const String _modeloTipoPiel =
      'assets/modelos/skin_type_classifier.tflite';
  static const String _labelsTipoPiel =
      'assets/modelos/skin_type_labels.txt';

  static const String _modeloAcne =
      'assets/modelos/acne_yolov8n.tflite';
  static const String _labelsAcne =
      'assets/modelos/acne_labels.txt';

  static const String _modeloCondiciones =
      'assets/modelos/skin_conditions_yolov8n.tflite';
  static const String _labelsCondiciones =
      'assets/modelos/skin_conditions_labels.txt';

  Interpreter? _tipoPielInterpreter;
  Interpreter? _acneInterpreter;
  Interpreter? _condicionesInterpreter;

  List<String> _tipoPielLabels = [];
  List<String> _acneLabels = [];
  List<String> _condicionesLabels = [];

  bool _modelosCargados = false;

  final double _umbralYoloGeneral = 0.08;
  final double _umbralNms = 0.45;

  Future<MlServicio> init() async {
    await cargarModelos();
    return this;
  }

  Future<void> cargarModelos() async {
    if (_modelosCargados) return;

    _tipoPielInterpreter = await Interpreter.fromAsset(_modeloTipoPiel);
    _acneInterpreter = await Interpreter.fromAsset(_modeloAcne);
    _condicionesInterpreter = await Interpreter.fromAsset(_modeloCondiciones);

    _tipoPielLabels = await _cargarLabels(_labelsTipoPiel);
    _acneLabels = await _cargarLabels(_labelsAcne);
    _condicionesLabels = await _cargarLabels(_labelsCondiciones);

    _modelosCargados = true;
  }

  Future<ResultadoAnalisis> analizarImagen(File imagenPath) async {
    await cargarModelos();

    final bytes = await imagenPath.readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw Exception('No se pudo leer la imagen seleccionada.');
    }

    final imagen = img.bakeOrientation(decoded);

    final tipoInicial = await _predecirTipoPiel(imagen);

    final deteccionesAcne = await _detectarConYolo(
      imagenOriginal: imagen,
      interpreter: _acneInterpreter!,
      labels: _acneLabels,
      origenModelo: 'acne_yolo',
    );

    final deteccionesCondiciones = await _detectarConYolo(
      imagenOriginal: imagen,
      interpreter: _condicionesInterpreter!,
      labels: _condicionesLabels,
      origenModelo: 'conditions_yolo',
    );

    final todasLasDetecciones = <DeteccionPiel>[
      ...deteccionesAcne,
      ...deteccionesCondiciones,
    ];

    final deteccionesFinales = _aplicarNmsGlobal(todasLasDetecciones);

    final tipoCorregido = _corregirTipoPielConDetecciones(
      tipoInicial,
      deteccionesFinales,
    );

    final severidad = _calcularSeveridadVisual(deteccionesFinales);

    final recomendaciones = _generarRecomendaciones(
      tipoPiel: tipoCorregido.tipoPiel,
      detecciones: deteccionesFinales,
      severidad: severidad,
    );

    return ResultadoAnalisis(
      imagen: imagenPath,
      tipoPiel: tipoCorregido.tipoPiel,
      confianzaTipoPiel: tipoCorregido.confianza,
      severidadVisual: severidad,
      detecciones: deteccionesFinales,
      rutinaDia: recomendaciones.rutinaDia,
      rutinaNoche: recomendaciones.rutinaNoche,
      alertas: recomendaciones.alertas,
    );
  }

  Future<ResultadoAnalisis> analizar(File imagenFile) => analizarImagen(imagenFile);
  Future<ResultadoAnalisis> procesarImagen(File imagenFile) => analizarImagen(imagenFile);

  Future<_TipoPielPrediccion> _predecirTipoPiel(img.Image imagenOriginal) async {
    final interpreter = _tipoPielInterpreter!;
    final inputShape = interpreter.getInputTensor(0).shape;

    final int inputH = inputShape.length == 4 ? inputShape[1] : 224;
    final int inputW = inputShape.length == 4 ? inputShape[2] : 224;

    final resized = img.copyResize(
      imagenOriginal,
      width: inputW,
      height: inputH,
      interpolation: img.Interpolation.linear,
    );

    final input = _crearInputImagen(resized, interpreter);

    final outputShape = interpreter.getOutputTensor(0).shape;
    final output = _crearOutput(outputShape);

    interpreter.run(input, output);

    final probs = _extraerVectorSalida(output);
    if (probs.isEmpty) {
      return _TipoPielPrediccion(
        tipoPiel: 'no determinado',
        confianza: 0.0,
        labelOriginal: 'unknown',
      );
    }

    int mejorIndice = 0;
    double mejorConfianza = probs[0];

    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > mejorConfianza) {
        mejorIndice = i;
        mejorConfianza = probs[i];
      }
    }

    final labelOriginal = mejorIndice < _tipoPielLabels.length
        ? _tipoPielLabels[mejorIndice]
        : 'unknown';

    return _TipoPielPrediccion(
      tipoPiel: _traducirTipoPiel(labelOriginal),
      confianza: mejorConfianza.clamp(0.0, 1.0),
      labelOriginal: labelOriginal,
    );
  }

  Future<List<DeteccionPiel>> _detectarConYolo({
    required img.Image imagenOriginal,
    required Interpreter interpreter,
    required List<String> labels,
    required String origenModelo,
  }) async {
    if (labels.isEmpty) return [];

    final inputShape = interpreter.getInputTensor(0).shape;

    final bool esNchw = inputShape.length == 4 && inputShape[1] == 3;
    final int inputH = esNchw ? inputShape[2] : inputShape[1];
    final int inputW = esNchw ? inputShape[3] : inputShape[2];
    final int inputSize = math.min(inputH, inputW);

    final letterbox = _letterbox(imagenOriginal, inputSize);

    final input = _crearInputImagen(letterbox.imagen, interpreter);

    final outputShape = interpreter.getOutputTensor(0).shape;
    final output = _crearOutput(outputShape);

    interpreter.run(input, output);

    final matriz = _extraerMatrizYolo(output, outputShape, labels.length);
    if (matriz.isEmpty) return [];

    final detecciones = <DeteccionPiel>[];

    for (final fila in matriz) {
      if (fila.length < 4 + labels.length) continue;

      final double rawX = fila[0];
      final double rawY = fila[1];
      final double rawW = fila[2];
      final double rawH = fila[3];

      final bool tieneObjectness = fila.length >= labels.length + 5;
      final int inicioClases = tieneObjectness ? 5 : 4;
      final double objectness = tieneObjectness ? _aProbabilidad(fila[4]) : 1.0;

      int mejorClase = 0;
      double mejorScoreClase = -1.0;

      for (int c = 0; c < labels.length; c++) {
        final int idx = inicioClases + c;
        if (idx >= fila.length) break;

        final score = _aProbabilidad(fila[idx]);
        if (score > mejorScoreClase) {
          mejorScoreClase = score;
          mejorClase = c;
        }
      }

      final labelOriginal = labels[mejorClase];
      final confianza = (mejorScoreClase * objectness).clamp(0.0, 1.0);

      final umbralClase = _umbralParaClase(labelOriginal);
      if (confianza < umbralClase) continue;

      double cx = rawX;
      double cy = rawY;
      double bw = rawW;
      double bh = rawH;

      final maxCoord = [cx, cy, bw, bh].reduce(math.max);
      if (maxCoord <= 2.0) {
        cx *= inputSize;
        cy *= inputSize;
        bw *= inputSize;
        bh *= inputSize;
      }

      double x1 = cx - bw / 2;
      double y1 = cy - bh / 2;
      double x2 = cx + bw / 2;
      double y2 = cy + bh / 2;

      x1 = (x1 - letterbox.padX) / letterbox.escala;
      y1 = (y1 - letterbox.padY) / letterbox.escala;
      x2 = (x2 - letterbox.padX) / letterbox.escala;
      y2 = (y2 - letterbox.padY) / letterbox.escala;

      x1 = x1.clamp(0.0, imagenOriginal.width.toDouble());
      y1 = y1.clamp(0.0, imagenOriginal.height.toDouble());
      x2 = x2.clamp(0.0, imagenOriginal.width.toDouble());
      y2 = y2.clamp(0.0, imagenOriginal.height.toDouble());

      final w = math.max(0.0, x2 - x1);
      final h = math.max(0.0, y2 - y1);

      if (w <= 1 || h <= 1) continue;

      detecciones.add(
        DeteccionPiel(
          etiquetaOriginal: labelOriginal,
          etiqueta: _traducirCondicion(labelOriginal),
          confianza: confianza,
          x: x1,
          y: y1,
          w: w,
          h: h,
          origenModelo: origenModelo,
        ),
      );
    }

    return _aplicarNms(detecciones, _umbralNms);
  }

  /// Umbral por clase
  double _umbralParaClase(String label) {
    final key = _normalizar(label);

    if (key.contains('blackhead')) return 0.035;
    if (key.contains('whitehead')) return 0.035;
    if (key.contains('pore')) return 0.040;
    if (key.contains('redness')) return 0.055;
    if (key.contains('dark') || key.contains('spot')) return 0.055;
    if (key.contains('wrinkle')) return 0.060;
    if (key.contains('eyebag') || key.contains('eye bag')) return 0.060;
    if (key.contains('oily')) return 0.055;
    if (key.contains('dry')) return 0.055;
    if (key.contains('acne') || key.contains('pimple')) return 0.060;

    return _umbralYoloGeneral;
  }

  _TipoPielPrediccion _corregirTipoPielConDetecciones(
    _TipoPielPrediccion inicial,
    List<DeteccionPiel> detecciones,
  ) {
    final conteo = _contarPorOriginal(detecciones);

    final bool hayGrasa = _existeCondicion(conteo, ['oily', 'oil']);
    final bool haySeca = _existeCondicion(conteo, ['dry']);
    final bool hayPoros = _existeCondicion(conteo, ['pore']);
    final bool hayPuntosNegros = _existeCondicion(conteo, ['blackhead']);
    final bool hayPuntosBlancos = _existeCondicion(conteo, ['whitehead']);

    String tipo = inicial.tipoPiel;
    double confianza = inicial.confianza;

    // Si el clasificador está bajo 60%, no es muy confiable.
    final bool clasificadorDudoso = confianza < 0.60;

    // si YOLO ve grasa/poros/puntos negros y el clasificador está dudoso,
    // priorizamos la evidencia visual.
    if (clasificadorDudoso && (hayGrasa || hayPoros || hayPuntosNegros)) {
      tipo = 'grasa';
      confianza = math.max(confianza, 0.62);
    }

    // si YOLO ve piel seca y el clasificador está dudoso, corregimos a seca.
    if (clasificadorDudoso && haySeca && !hayGrasa) {
      tipo = 'seca';
      confianza = math.max(confianza, 0.62);
    }

    // si hay señales mixtas, se muestra mixta/combinada.
    if ((hayGrasa || hayPoros || hayPuntosNegros || hayPuntosBlancos) && haySeca) {
      tipo = 'mixta';
      confianza = math.max(confianza, 0.65);
    }

    // si el clasificador dice seca pero YOLO detecta grasa/poros,
    // y la confianza no es alta, se corrige a mixta.
    if (inicial.tipoPiel == 'seca' &&
        confianza < 0.75 &&
        (hayGrasa || hayPoros || hayPuntosNegros)) {
      tipo = 'mixta';
      confianza = math.max(confianza, 0.64);
    }

    // si el clasificador dice normal pero hay varias condiciones,
    // evitamos venderlo como 100% normal.
    if (inicial.tipoPiel == 'normal' && detecciones.length >= 3) {
      if (hayGrasa || hayPoros || hayPuntosNegros) {
        tipo = 'grasa';
        confianza = math.max(confianza, 0.61);
      } else if (haySeca) {
        tipo = 'seca';
        confianza = math.max(confianza, 0.61);
      }
    }

    return _TipoPielPrediccion(
      tipoPiel: tipo,
      confianza: confianza.clamp(0.0, 1.0),
      labelOriginal: inicial.labelOriginal,
    );
  }

  String _calcularSeveridadVisual(List<DeteccionPiel> detecciones) {
    final total = detecciones.length;

    final acne = detecciones.where((d) {
      final key = _normalizar(d.etiquetaOriginal);
      return key.contains('acne') || key.contains('pimple');
    }).length;

    if (total == 0) return 'sin condición visible';

    final puntaje = total + acne;

    if (puntaje >= 16) return 'alta';
    if (puntaje >= 7) return 'moderada';
    return 'leve';
  }

  _Recomendaciones _generarRecomendaciones({
    required String tipoPiel,
    required List<DeteccionPiel> detecciones,
    required String severidad,
  }) {
    final conteo = _contarPorOriginal(detecciones);

    final bool acne = _existeCondicion(conteo, ['acne', 'pimple']);
    final bool puntosNegros = _existeCondicion(conteo, ['blackhead']);
    final bool puntosBlancos = _existeCondicion(conteo, ['whitehead']);
    final bool poros = _existeCondicion(conteo, ['pore']);
    final bool manchas = _existeCondicion(conteo, ['dark', 'spot', 'pigmentation']);
    final bool rojez = _existeCondicion(conteo, ['redness']);
    final bool grasa = tipoPiel == 'grasa' || _existeCondicion(conteo, ['oily']);
    final bool seca = tipoPiel == 'seca' || _existeCondicion(conteo, ['dry']);

    final rutinaDia = <String>[];
    final rutinaNoche = <String>[];
    final alertas = <String>[];

    rutinaDia.add('Limpieza suave y protector solar.');
    rutinaNoche.add('Limpieza suave antes de dormir.');

    if (grasa || poros || puntosNegros || puntosBlancos) {
      rutinaDia.add('Usar hidratante ligera no comedogénica.');
      rutinaNoche.add('Evitar productos muy grasos o pesados.');
    }

    if (seca) {
      rutinaDia.add('Reforzar hidratación durante el día.');
      rutinaNoche.add('Usar crema reparadora antes de dormir.');
    }

    if (acne) {
      rutinaDia.add('No manipular lesiones ni exprimir granitos.');
      rutinaNoche.add('Mantener rutina constante y evitar exfoliación agresiva.');
    }

    if (manchas) {
      rutinaDia.add('Aplicar protector solar de forma constante para prevenir mayor pigmentación.');
      rutinaNoche.add('Mantener hidratación y evitar irritación en zonas manchadas.');
    }

    if (rojez) {
      rutinaDia.add('Evitar productos con fragancia o alcohol si hay irritación.');
      rutinaNoche.add('Preferir productos calmantes y limpieza delicada.');
    }

    if (severidad == 'moderada' || severidad == 'alta') {
      alertas.add('El análisis es orientativo y no reemplaza una evaluación dermatológica.');
      alertas.add('Si hay dolor, inflamación intensa, pus o empeoramiento, consultar con un profesional.');
    } else {
      alertas.add('Resultado orientativo basado en la imagen analizada.');
    }

    if (detecciones.isEmpty) {
      rutinaDia
        ..clear()
        ..add('Mantener limpieza diaria, hidratación ligera y protector solar.');
      rutinaNoche
        ..clear()
        ..add('Realizar limpieza suave e hidratación básica.');
      alertas
        ..clear()
        ..add('No se detectaron condiciones visibles con suficiente confianza.');
    }

    return _Recomendaciones(
      rutinaDia: rutinaDia,
      rutinaNoche: rutinaNoche,
      alertas: alertas,
    );
  }

  Future<List<String>> _cargarLabels(String ruta) async {
    final contenido = await rootBundle.loadString(ruta);

    return contenido
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.replaceFirst(RegExp(r'^\d+\s+'), '').trim())
        .toList();
  }

  dynamic _crearInputImagen(img.Image image, Interpreter interpreter) {
    final inputTensor = interpreter.getInputTensor(0);
    final shape = inputTensor.shape;
    final type = inputTensor.type;

    final bool esUint8 = type.toString().toLowerCase().contains('uint8');
    final bool esNchw = shape.length == 4 && shape[1] == 3;

    final int h = esNchw ? shape[2] : shape[1];
    final int w = esNchw ? shape[3] : shape[2];

    final preparada = image.width == w && image.height == h
        ? image
        : img.copyResize(
            image,
            width: w,
            height: h,
            interpolation: img.Interpolation.linear,
          );

    num valorCanal(num v) {
      if (esUint8) return v.toInt();
      return v.toDouble() / 255.0;
    }

    if (esNchw) {
      return [
        List.generate(3, (c) {
          return List.generate(h, (y) {
            return List.generate(w, (x) {
              final p = preparada.getPixel(x, y);
              if (c == 0) return valorCanal(p.r);
              if (c == 1) return valorCanal(p.g);
              return valorCanal(p.b);
            });
          });
        })
      ];
    }

    return [
      List.generate(h, (y) {
        return List.generate(w, (x) {
          final p = preparada.getPixel(x, y);
          return [
            valorCanal(p.r),
            valorCanal(p.g),
            valorCanal(p.b),
          ];
        });
      })
    ];
  }

  dynamic _crearOutput(List<int> shape) {
    if (shape.length == 1) {
      return List<double>.filled(shape[0], 0.0);
    }

    if (shape.length == 2) {
      return List.generate(
        shape[0],
        (_) => List<double>.filled(shape[1], 0.0),
      );
    }

    if (shape.length == 3) {
      return List.generate(
        shape[0],
        (_) => List.generate(
          shape[1],
          (_) => List<double>.filled(shape[2], 0.0),
        ),
      );
    }

    if (shape.length == 4) {
      return List.generate(
        shape[0],
        (_) => List.generate(
          shape[1],
          (_) => List.generate(
            shape[2],
            (_) => List<double>.filled(shape[3], 0.0),
          ),
        ),
      );
    }

    throw Exception('Forma de salida no soportada: $shape');
  }

  List<double> _extraerVectorSalida(dynamic output) {
    final valores = <double>[];

    void recorrer(dynamic x) {
      if (x is List) {
        for (final item in x) {
          recorrer(item);
        }
      } else if (x is num) {
        valores.add(x.toDouble());
      }
    }

    recorrer(output);
    return valores;
  }

  List<List<double>> _extraerMatrizYolo(
    dynamic output,
    List<int> shape,
    int cantidadClases,
  ) {
    final filas = <List<double>>[];

    if (shape.length != 3) {
      return filas;
    }

    final dim1 = shape[1];
    final dim2 = shape[2];

    if (dim1 <= cantidadClases + 6 && dim2 > dim1) {
      final int atributos = dim1;
      final int cajas = dim2;

      for (int i = 0; i < cajas; i++) {
        final fila = <double>[];
        for (int a = 0; a < atributos; a++) {
          fila.add((output[0][a][i] as num).toDouble());
        }
        filas.add(fila);
      }

      return filas;
    }

    if (dim2 <= cantidadClases + 6 && dim1 > dim2) {
      final int cajas = dim1;
      final int atributos = dim2;

      for (int i = 0; i < cajas; i++) {
        final fila = <double>[];
        for (int a = 0; a < atributos; a++) {
          fila.add((output[0][i][a] as num).toDouble());
        }
        filas.add(fila);
      }

      return filas;
    }

    return filas;
  }

  double _aProbabilidad(double valor) {
    if (valor >= 0.0 && valor <= 1.0) return valor;
    return 1.0 / (1.0 + math.exp(-valor));
  }

  _LetterboxResult _letterbox(img.Image original, int size) {
    final escala = math.min(
      size / original.width,
      size / original.height,
    );

    final nuevoW = math.max(1, (original.width * escala).round());
    final nuevoH = math.max(1, (original.height * escala).round());

    final redimensionada = img.copyResize(
      original,
      width: nuevoW,
      height: nuevoH,
      interpolation: img.Interpolation.linear,
    );

    final canvas = img.Image(width: size, height: size);

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        canvas.setPixelRgb(x, y, 114, 114, 114);
      }
    }

    final padX = ((size - nuevoW) / 2).round();
    final padY = ((size - nuevoH) / 2).round();

    for (int y = 0; y < nuevoH; y++) {
      for (int x = 0; x < nuevoW; x++) {
        canvas.setPixel(padX + x, padY + y, redimensionada.getPixel(x, y));
      }
    }

    return _LetterboxResult(
      imagen: canvas,
      escala: escala,
      padX: padX.toDouble(),
      padY: padY.toDouble(),
    );
  }

  List<DeteccionPiel> _aplicarNmsGlobal(List<DeteccionPiel> detecciones) {
    final porClase = <String, List<DeteccionPiel>>{};

    for (final d in detecciones) {
      final key = _normalizar(d.etiquetaOriginal);
      porClase.putIfAbsent(key, () => []);
      porClase[key]!.add(d);
    }

    final salida = <DeteccionPiel>[];

    for (final lista in porClase.values) {
      salida.addAll(_aplicarNms(lista, _umbralNms));
    }

    salida.sort((a, b) => b.confianza.compareTo(a.confianza));
    return salida;
  }

  List<DeteccionPiel> _aplicarNms(
    List<DeteccionPiel> detecciones,
    double umbral,
  ) {
    if (detecciones.isEmpty) return [];

    final ordenadas = [...detecciones]
      ..sort((a, b) => b.confianza.compareTo(a.confianza));

    final seleccionadas = <DeteccionPiel>[];

    for (final actual in ordenadas) {
      bool agregar = true;

      for (final aceptada in seleccionadas) {
        final mismaClase =
            _normalizar(actual.etiquetaOriginal) ==
            _normalizar(aceptada.etiquetaOriginal);

        if (mismaClase && _calcularIou(actual, aceptada) > umbral) {
          agregar = false;
          break;
        }
      }

      if (agregar) {
        seleccionadas.add(actual);
      }
    }

    return seleccionadas;
  }

  double _calcularIou(DeteccionPiel a, DeteccionPiel b) {
    final ax1 = a.x;
    final ay1 = a.y;
    final ax2 = a.x + a.w;
    final ay2 = a.y + a.h;

    final bx1 = b.x;
    final by1 = b.y;
    final bx2 = b.x + b.w;
    final by2 = b.y + b.h;

    final interX1 = math.max(ax1, bx1);
    final interY1 = math.max(ay1, by1);
    final interX2 = math.min(ax2, bx2);
    final interY2 = math.min(ay2, by2);

    final interW = math.max(0.0, interX2 - interX1);
    final interH = math.max(0.0, interY2 - interY1);
    final interArea = interW * interH;

    final areaA = math.max(0.0, a.w) * math.max(0.0, a.h);
    final areaB = math.max(0.0, b.w) * math.max(0.0, b.h);
    final union = areaA + areaB - interArea;

    if (union <= 0) return 0.0;
    return interArea / union;
  }

  String _traducirTipoPiel(String label) {
    final key = _normalizar(label);

    if (key.contains('combination') ||
        key.contains('combined') ||
        key.contains('mixta')) {
      return 'mixta';
    }

    if (key.contains('oily') || key.contains('grasa')) {
      return 'grasa';
    }

    if (key.contains('dry') || key.contains('seca')) {
      return 'seca';
    }

    if (key.contains('normal')) {
      return 'normal';
    }

    return label.toLowerCase();
  }

  String _traducirCondicion(String label) {
    final key = _normalizar(label);

    if (key.contains('blackhead')) return 'Puntos negros';
    if (key.contains('whitehead')) return 'Puntos blancos';
    if (key.contains('dark') || key.contains('spot') || key.contains('pigmentation')) {
      return 'Manchas oscuras';
    }
    if (key.contains('pore')) return 'Poros dilatados';
    if (key.contains('redness')) return 'Enrojecimiento';
    if (key.contains('oily')) return 'Piel grasa';
    if (key.contains('dry')) return 'Piel seca';
    if (key.contains('eyebag') || key.contains('eye bag')) return 'Bolsas u ojeras';
    if (key.contains('wrinkle')) return 'Arrugas';
    if (key.contains('acne') || key.contains('pimple')) return 'Acné';

    return label;
  }

  String _normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll('/', ' ')
        .trim();
  }

  Map<String, int> _contarPorOriginal(List<DeteccionPiel> detecciones) {
    final conteo = <String, int>{};

    for (final d in detecciones) {
      final key = _normalizar(d.etiquetaOriginal);
      conteo[key] = (conteo[key] ?? 0) + 1;
    }

    return conteo;
  }

  bool _existeCondicion(Map<String, int> conteo, List<String> palabras) {
    for (final key in conteo.keys) {
      for (final palabra in palabras) {
        if (key.contains(palabra)) return true;
      }
    }
    return false;
  }

  void cerrar() {
    _tipoPielInterpreter?.close();
    _acneInterpreter?.close();
    _condicionesInterpreter?.close();

    _tipoPielInterpreter = null;
    _acneInterpreter = null;
    _condicionesInterpreter = null;

    _modelosCargados = false;
  }
}

class ResultadoAnalisis {
  final File imagen;
  final String tipoPiel;
  final double confianzaTipoPiel;
  final String severidadVisual;
  final List<DeteccionPiel> detecciones;

  final List<String> rutinaDia;
  final List<String> rutinaNoche;
  final List<String> alertas;

  ResultadoAnalisis({
    required this.imagen,
    required this.tipoPiel,
    required this.confianzaTipoPiel,
    required this.severidadVisual,
    required this.detecciones,
    required this.rutinaDia,
    required this.rutinaNoche,
    required this.alertas,
  });

  String get imagenPath => imagen.path;
  String get severidadGeneral => severidadVisual;

  List<String> get recomendacionesDia => rutinaDia;
  List<String> get recomendacionesNoche => rutinaNoche;
  List<String> get aclaraciones => alertas;

  int get totalDetecciones => detecciones.length;

  Map<String, int> get conteoCondiciones {
    final conteo = <String, int>{};
    for (final d in detecciones) {
      final etiqueta = d.etiqueta.trim().isEmpty ? 'Condición visible' : d.etiqueta.trim();
      conteo[etiqueta] = (conteo[etiqueta] ?? 0) + 1;
    }
    return conteo;
  }

  Map<String, int> get conteoPorCondicion => conteoCondiciones;

  String get condicionPrincipal {
    if (detecciones.isEmpty) return 'Sin condición visible';

    final ordenadas = [...detecciones]
      ..sort((a, b) => b.confianza.compareTo(a.confianza));

    final etiqueta = ordenadas.first.etiqueta.trim();
    return etiqueta.isEmpty ? 'Condición visible' : etiqueta;
  }

  double get confianzaCondicionPrincipal {
    if (detecciones.isEmpty) return 0;

    final ordenadas = [...detecciones]
      ..sort((a, b) => b.confianza.compareTo(a.confianza));

    return ordenadas.first.confianza;
  }
}

class DeteccionPiel {
  final String etiquetaOriginal;
  final String etiqueta;
  final double confianza;

  final double x;
  final double y;
  final double w;
  final double h;

  final String origenModelo;

  DeteccionPiel({
    required this.etiquetaOriginal,
    required this.etiqueta,
    required this.confianza,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.origenModelo,
  });

  String get confianzaPorcentaje => '${(confianza * 100).toStringAsFixed(1)}%';
}

class _TipoPielPrediccion {
  final String tipoPiel;
  final double confianza;
  final String labelOriginal;

  _TipoPielPrediccion({
    required this.tipoPiel,
    required this.confianza,
    required this.labelOriginal,
  });
}

class _Recomendaciones {
  final List<String> rutinaDia;
  final List<String> rutinaNoche;
  final List<String> alertas;

  _Recomendaciones({
    required this.rutinaDia,
    required this.rutinaNoche,
    required this.alertas,
  });
}

class _LetterboxResult {
  final img.Image imagen;
  final double escala;
  final double padX;
  final double padY;

  _LetterboxResult({
    required this.imagen,
    required this.escala,
    required this.padX,
    required this.padY,
  });
}
