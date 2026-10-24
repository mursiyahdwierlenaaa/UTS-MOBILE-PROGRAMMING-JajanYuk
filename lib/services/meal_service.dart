
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal.dart';

class MealService {
  static const String _baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // Mengambil daftar resep kategori Dessert.
  Future<List<Meal>> fetchDesserts() async {
    final url = Uri.parse('$_baseUrl/filter.php?c=Dessert');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil daftar resep (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);
    final meals = data['meals'];

    if (meals == null) {
      return [];
    }

    return (meals as List)
        .map(
          (item) => Meal.fromListJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  // Mengambil detail resep berdasarkan ID.
  Future<Meal> fetchMealDetails(String id) async {
    final url = Uri.parse('$_baseUrl/lookup.php?i=$id');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil detail resep (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);
    final meals = data['meals'];

    if (meals == null || (meals as List).isEmpty) {
      throw Exception('Detail resep tidak ditemukan.');
    }

    return Meal.fromDetailJson(
      meals.first as Map<String, dynamic>,
    );
  }
}
