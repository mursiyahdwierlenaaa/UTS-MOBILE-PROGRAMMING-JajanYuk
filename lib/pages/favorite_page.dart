
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/meal.dart';
import '../services/favorite_service.dart';
import '../services/meal_service.dart';
import 'recipe_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    FavoriteService.instance.loadFavorites();
  }

  // Membuka detail resep ketika kartu resep diklik.
  Future<void> _openRecipeDetail(Meal meal) async {
    bool loadingOpen = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.maroon,
          ),
        );
      },
    );

    try {
      final detail =
      await MealService().fetchMealDetails(meal.id);

      if (!mounted) return;

      // Tutup indikator loading.
      Navigator.of(context, rootNavigator: true).pop();
      loadingOpen = false;

      // Pisahkan instruksi menjadi beberapa langkah.
      final steps = detail.instructions
          .split(RegExp(r'\r?\n+'))
          .map((step) => step.trim())
          .where((step) => step.isNotEmpty)
          .toList();

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailPage(
            id: detail.id,
            name: detail.name,
            category: detail.category,
            imageUrl: detail.thumbnail,
            description: detail.category,
            cookingTime: 'Waktu memasak tidak tersedia',
            servings: 1,
            ingredients: detail.ingredients,
            steps: steps,
            youtubeUrl: detail.youtube.isEmpty
                ? null
                : detail.youtube,
            cookingTip:
            'Siapkan semua bahan sebelum mulai memasak.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      // Tutup loading hanya jika masih terbuka.
      if (loadingOpen) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal membuka detail resep. Periksa koneksi internet.',
          ),
        ),
      );
    }
  }

  // Menghapus resep dari daftar favorit.
  Future<void> _removeFavorite(Meal meal) async {
    await FavoriteService.instance.toggleFavorite(meal);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resep dihapus dari favorit.'),
      ),
    );
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
          'Resep Favorit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: FavoriteService.instance,
        builder: (context, child) {
          final favorites =
              FavoriteService.instance.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 76,
                      color: AppColors.lightBrown,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum Ada Resep Favorit',
                      style: TextStyle(
                        color: AppColors.maroon,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Simpan resep yang kamu sukai '
                          'agar mudah ditemukan di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.brown,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: favorites.length,
            separatorBuilder: (context, index) =>
            const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final meal = favorites[index];

              return _FavoriteCard(
                meal: meal,
                onTap: () => _openRecipeDetail(meal),
                onRemove: () => _removeFavorite(meal),
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.meal,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.lightBrown.withValues(
                alpha: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  meal.thumbnail,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: AppColors.lightBrown,
                      child: const Icon(
                        Icons.cake_outlined,
                        color: AppColors.maroon,
                        size: 34,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.maroon,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ketuk untuk melihat detail resep',
                      style: TextStyle(
                        color: AppColors.brown,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Hapus dari favorit',
                onPressed: onRemove,
                icon: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.maroon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
