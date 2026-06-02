import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashServicio {
  final String accessKey;
  final http.Client _client;

  UnsplashServicio({
    required this.accessKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<String?> buscarImagen(String query) async {
    if (query.trim().isEmpty) return null;

    try {
      final uri = Uri.parse(
        'https://api.unsplash.com/search/photos'
        '?query=${Uri.encodeComponent(query)}'
        '&per_page=1',
      );

      final response = await _client.get(
        uri,
        headers: {'Authorization': 'Client-ID $accessKey'},
      );

      if (response.statusCode != 200) return null;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final results = body['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) return null;

      final first = results[0] as Map<String, dynamic>;
      final urls = first['urls'] as Map<String, dynamic>?;

      return urls?['small'] as String?;
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
