
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';

class FavoriteService extends ChangeNotifier {
  FavoriteService._();

  static final FavoriteService instance = FavoriteService._();

  static const String _storageKey = 'jajanyuk_favorites';

  final List<Meal> _favorites = [];

  List<Meal> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String id) {
    return _favorites.any((meal) => meal.id == id);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    _favorites.clear();

    if (savedData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedData);

        for (final item in decoded) {
          _favorites.add(
            Meal.fromListJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      } catch (_) {
        _favorites.clear();
      }
    }

    notifyListeners();
  }

  Future<void> toggleFavorite(Meal meal) async {
    final index = _favorites.indexWhere(
          (item) => item.id == meal.id,
    );

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(meal);
    }

    final prefs = await SharedPreferences.getInstance();

    final savedData = _favorites.map((item) {
      return {
        'idMeal': item.id,
        'strMeal': item.name,
        'strMealThumb': item.thumbnail,
      };
    }).toList();

    await prefs.setString(_storageKey, jsonEncode(savedData));

    notifyListeners();
  }
}
