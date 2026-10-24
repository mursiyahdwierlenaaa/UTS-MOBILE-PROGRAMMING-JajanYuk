
class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String instructions;
  final String youtube;
  final List<Map<String, String>> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category = 'Dessert',
    this.instructions = '',
    this.youtube = '',
    this.ingredients = const [],
  });

  factory Meal.fromListJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? 'Resep tanpa nama',
      thumbnail: json['strMealThumb']?.toString() ?? '',
    );
  }

  factory Meal.fromDetailJson(Map<String, dynamic> json) {
    final List<Map<String, String>> ingredientList = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient =
          json['strIngredient$i']?.toString().trim() ?? '';
      final measure =
          json['strMeasure$i']?.toString().trim() ?? '';

      if (ingredient.isNotEmpty) {
        ingredientList.add({
          'name': ingredient,
          'measure': measure,
        });
      }
    }

    return Meal(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? 'Resep tanpa nama',
      thumbnail: json['strMealThumb']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? 'Dessert',
      instructions: json['strInstructions']?.toString() ?? '',
      youtube: json['strYoutube']?.toString() ?? '',
      ingredients: ingredientList,
    );
  }
}
