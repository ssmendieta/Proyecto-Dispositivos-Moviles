class DeteccionPiel{
  final String etiqueta;
  final double confianza;

  final double x;
  final double y;
  final double ancho;
  final double alto;

  DeteccionPiel({
    required this.etiqueta,
    required this.confianza,
    required this.x,
    required this.y,
    required this.ancho,
    required this.alto,
  });

  Map<String, dynamic> toJson() {
    return {
      'etiqueta': etiqueta,
      'confianza': confianza,
      'x': x,
      'y': y,
      'ancho': ancho,
      'alto': alto,
    };
  }

  factory DeteccionPiel.fromJson(Map<String, dynamic> json) {
    return DeteccionPiel(
      etiqueta: json['etiqueta'],
      confianza: (json['confianza'] as num).toDouble(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      ancho: (json['ancho'] as num).toDouble(),
      alto: (json['alto'] as num).toDouble(),
    );
  }
}

class ResultadoAnalisis {
  final String imagenPath;

  final String tipoPiel;
  final double confianzaTipoPiel;

  final List<DeteccionPiel> detecciones;

  final String severidadGeneral;
  final List<String> rutinaDia;
  final List<String> rutinaNoche;
  final List<String> alertas;

  final DateTime fecha;

  ResultadoAnalisis({
    required this.imagenPath,
    required this.tipoPiel,
    required this.confianzaTipoPiel,
    required this.detecciones,
    required this.severidadGeneral,
    required this.rutinaDia,
    required this.rutinaNoche,
    required this.alertas,
    required this.fecha,
  });

  int get totalDetecciones => detecciones.length;

  Map<String, int> get conteoPorCondicion {
    final Map<String, int> conteo = {};

    for (final deteccion in detecciones) {
      conteo[deteccion.etiqueta] = (conteo[deteccion.etiqueta] ?? 0) + 1;
    }

    return conteo;
  }

  String get condicionPrincipal {
    if (detecciones.isEmpty) return 'Sin condición visible';

    final conteo = conteoPorCondicion;
    final ordenado = conteo.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ordenado.first.key;
  }

  Map<String, dynamic> toJson() {
    return {
      'imagenPath': imagenPath,
      'tipoPiel': tipoPiel,
      'confianzaTipoPiel': confianzaTipoPiel,
      'detecciones': detecciones.map((e) => e.toJson()).toList(),
      'severidadGeneral': severidadGeneral,
      'rutinaDia': rutinaDia,
      'rutinaNoche': rutinaNoche,
      'alertas': alertas,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory ResultadoAnalisis.fromJson(Map<String, dynamic> json) {
    return ResultadoAnalisis(
      imagenPath: json['imagenPath'],
      tipoPiel: json['tipoPiel'],
      confianzaTipoPiel: (json['confianzaTipoPiel'] as num).toDouble(),
      detecciones: (json['detecciones'] as List)
          .map((e) => DeteccionPiel.fromJson(e))
          .toList(),
      severidadGeneral: json['severidadGeneral'],
      rutinaDia: List<String>.from(json['rutinaDia']),
      rutinaNoche: List<String>.from(json['rutinaNoche']),
      alertas: List<String>.from(json['alertas']),
      fecha: DateTime.parse(json['fecha']),
    );
  }
}