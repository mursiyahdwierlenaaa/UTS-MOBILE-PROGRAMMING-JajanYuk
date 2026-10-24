
import 'package:flutter/material.dart';

import 'core/app_colors.dart';
import 'pages/main_navigation_page.dart';
import 'services/favorite_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FavoriteService.instance.loadFavorites();

  runApp(const JajanYukApp());
}

class JajanYukApp extends StatelessWidget {
  const JajanYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JajanYuk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.maroon,
          primary: AppColors.maroon,
          surface: AppColors.cream,
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}
