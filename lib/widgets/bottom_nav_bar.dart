
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.menu_book_outlined,
    Icons.add,
    Icons.favorite_border_rounded,
    Icons.person_outline_rounded,
  ];

  static const List<String> _labels = [
    'Beranda',
    'Resep',
    'Tambah',
    'Favorit',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        border: Border(
          top: BorderSide(
            color: AppColors.lightBrown.withValues(alpha: 0.65),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_labels.length, (index) {
              final isActive = currentIndex == index;
              final isFeatured = index == 2;

              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 58,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isFeatured ? 50 : 42,
                        height: isFeatured ? 46 : 38,
                        decoration: BoxDecoration(
                          color: isFeatured
                              ? AppColors.maroon
                              : isActive
                              ? AppColors.lightBrown.withValues(
                            alpha: 0.6,
                          )
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _icons[index],
                          color: isFeatured || isActive
                              ? AppColors.cream
                              : AppColors.brown,
                          size: isFeatured ? 28 : 25,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _labels[index],
                        maxLines: 1,
                        style: TextStyle(
                          color: isActive || isFeatured
                              ? AppColors.maroon
                              : AppColors.brown,
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
