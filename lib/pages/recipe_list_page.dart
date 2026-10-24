
import 'package:flutter/material.dart';
import 'recipe_detail_page.dart';
import '../core/app_colors.dart';
import '../models/meal.dart';
import '../services/favorite_service.dart';
import '../services/meal_service.dart';


class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final MealService _mealService = MealService();
  final TextEditingController _searchController =
  TextEditingController();

  late Future<List<Meal>> _recipesFuture;

  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Cake',
    'Cookies',
    'Donut',
    'Pudding',
    'Brownies',
  ];

  @override
  void initState() {
    super.initState();
    _recipesFuture = _mealService.fetchDesserts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reloadRecipes() {
    setState(() {
      _recipesFuture = _mealService.fetchDesserts();
    });
  }

  List<Meal> _filterRecipes(List<Meal> recipes) {
    final query = _searchController.text.toLowerCase().trim();

    return recipes.where((recipe) {
      final name = recipe.name.toLowerCase();
      final matchesSearch = name.contains(query);

      bool matchesCategory;

      switch (_selectedCategory) {
        case 'Cake':
          matchesCategory = name.contains('cake');
          break;
        case 'Cookies':
          matchesCategory =
              name.contains('cookie') || name.contains('biscuit');
          break;
        case 'Donut':
          matchesCategory =
              name.contains('donut') || name.contains('doughnut');
          break;
        case 'Pudding':
          matchesCategory = name.contains('pudding');
          break;
        case 'Brownies':
          matchesCategory = name.contains('brownie');
          break;
        default:
          matchesCategory = true;
      }

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> _openRecipeDetail(Meal recipe) async {
    try {
      final detail =
      await _mealService.fetchMealDetails(recipe.id);

      if (!mounted) return;

      final steps = detail.instructions
          .split(RegExp(r'\r?\n+'))
          .map((step) => step.trim())
          .where((step) => step.isNotEmpty)
          .toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailPage(
            id: detail.id,
            name: detail.name,
            category: detail.category,
            imageUrl: detail.thumbnail,
            description: detail.instructions,
            cookingTime: 'Lihat langkah memasak',
            servings: 4,
            ingredients: detail.ingredients,
            steps: steps,
            youtubeUrl: detail.youtube,
            cookingTip:
            'Siapkan semua bahan sebelum mulai memasak.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka detail resep: $e'),
          backgroundColor: AppColors.maroon,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.maroon,
        elevation: 0,
        title: const Text(
          'Dessert Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find Your Favorite Dessert',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search dessert...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.maroon,
                      ),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected =
                            category == _selectedCategory;

                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: AppColors.maroon,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.brown,
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore Desserts',
                    style: TextStyle(
                      color: AppColors.maroon,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<List<Meal>>(
                    future: _recipesFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final filtered =
                      _filterRecipes(snapshot.data!);

                      return Text(
                        '${filtered.length} recipes',
                        style: const TextStyle(
                          color: AppColors.brown,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Meal>>(
                future: _recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.maroon,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off,
                              size: 48,
                              color: AppColors.brown,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Resep gagal dimuat.',
                              style: TextStyle(
                                color: AppColors.maroon,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Periksa koneksi internet lalu coba lagi.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.brown,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _reloadRecipes,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.maroon,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final recipes =
                  _filterRecipes(snapshot.data ?? []);

                  if (recipes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Resep tidak ditemukan.',
                        style: TextStyle(
                          color: AppColors.brown,
                          fontSize: 15,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20, 0, 20, 24,
                    ),
                    itemCount: recipes.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.66,
                    ),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return _RecipeCard(
                        recipe: recipe,
                        onTap: () => _openRecipeDetail(recipe),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Meal recipe;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.recipe,
    required this.onTap,
  });

  Future<void> _toggleFavorite(BuildContext context) async {
    final favoriteService = FavoriteService.instance;
    final wasFavorite = favoriteService.isFavorite(recipe.id);

    try {
      await favoriteService.toggleFavorite(recipe);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              wasFavorite
                  ? 'Resep dihapus dari Favorit'
                  : 'Resep ditambahkan ke Favorit',
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: AppColors.maroon,
          ),
        );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan Favorit. Coba lagi.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    recipe.thumbnail,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Container(
                        color: AppColors.lightBrown,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: AppColors.maroon,
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.lightBrown,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.cake_outlined,
                          color: AppColors.maroon,
                          size: 42,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: AnimatedBuilder(
                        animation: FavoriteService.instance,
                        builder: (context, child) {
                          final isFavorite =
                          FavoriteService.instance
                              .isFavorite(recipe.id);

                          return IconButton(
                            tooltip: isFavorite
                                ? 'Hapus dari Favorit'
                                : 'Tambahkan ke Favorit',
                            onPressed: () =>
                                _toggleFavorite(context),
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.maroon,
                              size: 20,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            padding: const EdgeInsets.all(8),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dessert',
                      style: TextStyle(
                        color: AppColors.brown,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.maroon,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          color: AppColors.brown,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Lihat resep',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.brown,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          color: AppColors.dustyPink,
                          size: 7,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Dessert',
                          style: TextStyle(
                            color: AppColors.brown,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
