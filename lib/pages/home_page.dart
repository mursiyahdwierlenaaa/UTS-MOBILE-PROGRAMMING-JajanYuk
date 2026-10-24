
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'favorite_page.dart';
import 'profile_page.dart';
import 'recipe_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openRecipeList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RecipeListPage(),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void _openFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          key: const PageStorageKey('jajanyuk_home'),
          primary: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            _buildHeader(context),
            const SizedBox(height: 28),
            _buildGreeting(),
            const SizedBox(height: 24),
            _buildSearchBar(context),
            const SizedBox(height: 30),
            _buildFeaturedRecipe(context),
            const SizedBox(height: 30),
            _buildSectionHeader(
              context: context,
              title: 'Kategori Pilihan',
              action: 'Lihat semua',
            ),
            const SizedBox(height: 12),
            _buildCategories(context),
            const SizedBox(height: 28),
            _buildSectionHeader(
              context: context,
              title: 'Rekomendasi Untukmu',
              action: 'Lihat Semua',
            ),
            const SizedBox(height: 4),
            const Text(
              'Dipilih sesuai selera manismu',
              style: TextStyle(
                color: AppColors.brown,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),
            _buildRecommendations(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Header aplikasi.
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.maroon,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.cake_outlined,
            color: AppColors.cream,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'JajanYuk',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.maroon,
                ),
              ),
              Text(
                'Resep manis, momen hangat',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.brown,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fitur notifikasi belum tersedia.',
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.brown,
            size: 25,
          ),
        ),
        GestureDetector(
          onTap: () => _openProfile(context),
          child: const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.brown,
            child: Text(
              'M',
              style: TextStyle(
                color: AppColors.cream,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Sapaan pengguna.
  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HALO, MURSIYAH',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
            color: AppColors.maroon,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Mau bikin dessert apa\nhari ini?',
          style: TextStyle(
            fontSize: 30,
            height: 1.2,
            color: AppColors.brown,
          ),
        ),
      ],
    );
  }

  // Kolom pencarian.
  Widget _buildSearchBar(BuildContext context) {
    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () => _openRecipeList(context),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.lightBrown,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: AppColors.brown,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Cari cake, cookies, pudding...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.maroon,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.cream,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Resep unggulan.
  Widget _buildFeaturedRecipe(BuildContext context) {
    return Container(
      height: 250,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.lightBrown.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 2, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'RESEP HARI INI',
                    style: TextStyle(
                      color: AppColors.maroon,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chocolate Lava Cake',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.maroon,
                      fontSize: 22,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Lembut di luar, lumer di tengah.',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _openRecipeList(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      foregroundColor: AppColors.cream,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Lihat Resep'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ClipOval(
                child: Image.network(
                  'https://www.themealdb.com/images/media/meals/tqtywx1468317395.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.lightBrown,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.cake_rounded,
                        color: AppColors.maroon,
                        size: 54,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Judul bagian dan tombol lihat semua.
  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
    required String action,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.maroon,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _openRecipeList(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.maroon,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: Text(
            action,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  // Daftar kategori.
  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 122,
      child: ListView(
        primary: false,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _CategoryCard(
            icon: Icons.cake_outlined,
            title: 'Cake',
            onTap: () => _openRecipeList(context),
          ),
          _CategoryCard(
            icon: Icons.cookie_outlined,
            title: 'Cookies',
            onTap: () => _openRecipeList(context),
          ),
          _CategoryCard(
            icon: Icons.cake_rounded,
            title: 'Donat',
            onTap: () => _openRecipeList(context),
          ),
          _CategoryCard(
            icon: Icons.access_time_rounded,
            title: 'Cepat',
            onTap: () => _openRecipeList(context),
          ),
          _CategoryCard(
            icon: Icons.play_circle_outline_rounded,
            title: 'Trending',
            onTap: () => _openRecipeList(context),
          ),
        ],
      ),
    );
  }

  // Daftar rekomendasi resep.
  Widget _buildRecommendations(BuildContext context) {
    return SizedBox(
      height: 222,
      child: ListView(
        primary: false,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _RecipeCard(
            title: 'Chocolate Cake',
            category: 'Cake',
            cookingTime: '45 menit',
            imageUrl:
            'https://www.themealdb.com/images/media/meals/tqtywx1468317395.jpg',
            onTap: () => _openRecipeList(context),
          ),
          _RecipeCard(
            title: 'Brownies Fudgy',
            category: 'Brownies',
            cookingTime: '45 menit',
            imageUrl:
            'https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg',
            onTap: () => _openRecipeList(context),
          ),
          _RecipeCard(
            title: 'Chocolate Chip Cookies',
            category: 'Cookies',
            cookingTime: '30 menit',
            imageUrl:
            'https://www.themealdb.com/images/media/meals/1548772327.jpg',
            onTap: () => _openRecipeList(context),
          ),
        ],
      ),
    );
  }
}

// Kartu kategori.
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      margin: const EdgeInsets.only(right: 12, bottom: 5),
      child: Material(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.lightBrown.withValues(alpha: 0.75),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brown.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightBrown.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.maroon,
                    size: 23,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.brown,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Kartu rekomendasi resep.
class _RecipeCard extends StatelessWidget {
  final String title;
  final String category;
  final String cookingTime;
  final String imageUrl;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.title,
    required this.category,
    required this.cookingTime,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12, bottom: 5),
      child: Material(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.lightBrown.withValues(alpha: 0.55),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brown.withValues(alpha: 0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 128,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.lightBrown,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.cake_outlined,
                              color: AppColors.maroon,
                              size: 38,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 9,
                        left: 9,
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 100,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.maroon,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: SizedBox(
                          width: 34,
                          height: 34,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.cream,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_border_rounded,
                              size: 19,
                              color: AppColors.maroon,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(11, 9, 11, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.brown,
                            fontSize: 12,
                            height: 1.25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: AppColors.brown,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              cookingTime,
                              style: const TextStyle(
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
        ),
      ),
    );
  }
}
