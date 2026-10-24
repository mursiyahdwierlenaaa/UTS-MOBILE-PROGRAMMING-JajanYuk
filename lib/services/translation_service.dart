
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TranslationService {
  TranslationService._();

  static final TranslationService instance = TranslationService._();

  static const String _endpoint =
      'https://api.mymemory.translated.net/get';

  final Map<String, String> _cache = {};

  Future<String> translateToIndonesian(String text) async {
    final original = text.trim();

    if (original.isEmpty) return original;
    if (_cache.containsKey(original)) return _cache[original]!;

    try {
      final uri = Uri.parse(_endpoint).replace(
        queryParameters: {
          'q': original,
          'langpair': 'en|id',
        },
      );

      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data is Map && data['responseData'] is Map) {
        final translated =
        data['responseData']['translatedText']?.toString().trim();

        final status = data['responseStatus'];

        if (status == 200 &&
            translated != null &&
            translated.isNotEmpty) {
          _cache[original] = translated;
          return translated;
        }
      }

      debugPrint('Terjemahan tidak tersedia untuk: $original');
    } catch (error) {
      debugPrint('Gagal menerjemahkan resep: $error');
    }

    return original;
  }

  Future<List<String>?> translateSteps(List<String> steps) async {
    final results = <String>[];

    for (final step in steps) {
      if (step.trim().isEmpty) {
        results.add(step);
        continue;
      }

      final translated = await translateToIndonesian(step);
      results.add(translated);

      // Mengurangi risiko permintaan terlalu cepat.
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return results;
  }
}
