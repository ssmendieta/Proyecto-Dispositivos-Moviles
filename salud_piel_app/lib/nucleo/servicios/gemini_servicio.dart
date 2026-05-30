import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';

class InformacionCondicion {
  final String descripcion;
  final List<String> causas;
  final String? recomendacionDermatologo;
  final List<String> consejosCuidado;

  InformacionCondicion({
    required this.descripcion,
    required this.causas,
    this.recomendacionDermatologo,
    required this.consejosCuidado,
  });
}

class GeminiServicio extends GetxService {
  GenerativeModel? _model;

  GenerativeModel? get _modelo {
    if (_model != null) return _model;
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'tu_api_key_de_gemini_aqui') {
      return null;
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3,
        responseMimeType: 'application/json',
      ),
    );
    return _model;
  }

  Future<InformacionCondicion?> informacionCondicion({
    required CondicionPiel condicion,
    double confianza = 0.0,
  }) async {
    final modelo = _modelo;
    if (modelo == null) return null;

    final conectado = await _tieneInternet();
    if (!conectado) return null;

    final prompt = '''
Eres un dermatólogo virtual. Dada la condición de piel "${condicion.displayName}" con ${(confianza * 100).round()}% de confianza, proporciona información útil.

Responde SOLO con JSON sin markdown ni caracteres de escape:
{
  "descripcion": "Descripción breve y clara de la condición en español (~3-5 oraciones)",
  "causas": ["Causa 1", "Causa 2", "Causa 3"],
  "recomendacionDermatologo": "Si es severo o preocupante, indica cuándo acudir al dermatólogo. Si es leve, indica que puede manejarse con cuidado diario.",
  "consejosCuidado": ["Consejo 1", "Consejo 2", "Consejo 3"]
}
''';

    try {
      final response = await modelo.generateContent([Content.text(prompt)]);
      final texto = response.text;
      if (texto == null || texto.isEmpty) return null;

      final json = jsonDecode(texto) as Map<String, dynamic>;
      return InformacionCondicion(
        descripcion: json['descripcion'] as String? ?? '',
        causas: (json['causas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        recomendacionDermatologo: json['recomendacionDermatologo'] as String?,
        consejosCuidado: (json['consejosCuidado'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> _tieneInternet() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}
