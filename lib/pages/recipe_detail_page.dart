
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import '../services/translation_service.dart';

class RecipeDetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final String cookingTime;
  final int servings;
  final List<Map<String, String>> ingredients;
  final List<String> steps;
  final String? youtubeUrl;
  final String cookingTip;

  const RecipeDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.cookingTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
    this.youtubeUrl,
    required this.cookingTip,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isTranslating = true;
  bool _translationAvailable = false;
  bool _openingVideo = false;

  List<String> _displaySteps = [];

  @override
  void initState() {
    super.initState();
    _translateRecipeSteps();
  }

  Future<void> _translateRecipeSteps() async {
    final sourceSteps = widget.steps
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();

    if (sourceSteps.isEmpty) {
      if (!mounted) return;
      setState(() {
        _displaySteps = [];
        _isTranslating = false;
        _translationAvailable = false;
      });
      return;
    }

    try {
      final translatedSteps =
      await TranslationService.instance.translateSteps(sourceSteps);

      if (!mounted) return;

      final valid = translatedSteps != null &&
          translatedSteps.length == sourceSteps.length &&
          translatedSteps.every((step) => step.trim().isNotEmpty);

      setState(() {
        _displaySteps = valid ? translatedSteps : sourceSteps;
        _translationAvailable = valid &&
            List.generate(
              sourceSteps.length,
                  (index) =>
              translatedSteps[index].trim().toLowerCase() !=
                  sourceSteps[index].trim().toLowerCase(),
            ).any((changed) => changed);
        _isTranslating = false;
      });
    } catch (error) {
      debugPrint('Terjemahan resep gagal: $error');
      if (!mounted) return;

      setState(() {
        _displaySteps = sourceSteps;
        _translationAvailable = false;
        _isTranslating = false;
      });
    }
  }

  Future<void> _openVideo() async {
    final url = widget.youtubeUrl?.trim();

    if (url == null || url.isEmpty) {
      _showMessage('Video resep belum tersedia.');
      return;
    }

    setState(() => _openingVideo = true);

    try {
      final uri = Uri.tryParse(url);

      if (uri == null ||
          (uri.scheme != 'https' && uri.scheme != 'http')) {
        _showMessage('Tautan video tidak valid.');
        return;
      }

      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) _showMessage('Tidak dapat membuka video.');
    } catch (error) {
      debugPrint('Gagal membuka video: $error');
      _showMessage('Gagal membuka video resep.');
    } finally {
      if (mounted) setState(() => _openingVideo = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.maroon,
      ),
    );
  }

  String _translateIngredient(String ingredient) {
    const dictionary = <String, String>{
      'all-purpose flour': 'tepung terigu',
      'plain flour': 'tepung terigu',
      'flour': 'tepung',
      'caster sugar': 'gula kastor',
      'brown sugar': 'gula merah',
      'powdered sugar': 'gula halus',
      'icing sugar': 'gula halus',
      'sugar': 'gula',
      'butter': 'mentega',
      'eggs': 'telur',
      'egg': 'telur',
      'milk': 'susu',
      'water': 'air',
      'salt': 'garam',
      'vanilla extract': 'ekstrak vanila',
      'baking powder': 'baking powder',
      'baking soda': 'soda kue',
      'cocoa powder': 'bubuk kakao',
      'dark chocolate': 'cokelat hitam',
      'chocolate': 'cokelat',
      'heavy cream': 'krim kental',
      'cream cheese': 'keju krim',
      'cream': 'krim',
      'condensed milk': 'susu kental manis',
      'coconut milk': 'santan',
      'vegetable oil': 'minyak sayur',
      'lemon juice': 'air lemon',
      'honey': 'madu',
      'cornstarch': 'tepung maizena',
      'strawberries': 'stroberi',
      'strawberry': 'stroberi',
      'bananas': 'pisang',
      'banana': 'pisang',
      'raisins': 'kismis',
      'walnuts': 'kacang kenari',
      'almonds': 'almon',
      'almond': 'almon',
    };

    var result = ingredient;
    final entries = dictionary.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

    for (final entry in entries) {
      result = result.replaceAll(
        RegExp(RegExp.escape(entry.key), caseSensitive: false),
        entry.value,
      );
    }

    return result;
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
          'Detail Resep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.lightBrown,
                child: const Icon(
                  Icons.cake_outlined,
                  size: 64,
                  color: AppColors.maroon,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category,
                  style: const TextStyle(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: AppColors.maroon,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.people_outline,
                        color: AppColors.brown),
                    const SizedBox(width: 6),
                    Text('${widget.servings} porsi'),
                    const SizedBox(width: 18),
                    const Icon(Icons.restaurant_menu,
                        color: AppColors.brown),
                    const SizedBox(width: 6),
                    Expanded(child: Text(widget.cookingTime)),
                  ],
                ),
                const SizedBox(height: 24),
                _sectionTitle('Bahan-bahan'),
                const SizedBox(height: 10),
                if (widget.ingredients.isEmpty)
                  const Text('Bahan belum tersedia.')
                else
                  ...widget.ingredients.map((ingredient) {
                    final name = ingredient['name'] ?? '';
                    final measure = ingredient['measure'] ?? '';

                    final translatedName = _translateIngredient(name);
                    final text = [
                      measure.trim(),
                      translatedName.trim(),
                    ].where((value) => value.isNotEmpty).join(' ');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 7,
                            color: AppColors.maroon,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(text)),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 24),
                _sectionTitle('Langkah Memasak'),
                const SizedBox(height: 10),
                if (_isTranslating)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.maroon,
                          ),
                          SizedBox(height: 12),
                          Text('Menerjemahkan langkah memasak...'),
                        ],
                      ),
                    ),
                  )
                else if (_displaySteps.isEmpty)
                  const Text('Langkah memasak belum tersedia.')
                else ...[
                    if (!_translationAvailable)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Terjemahan otomatis belum tersedia. '
                              'Langkah asli ditampilkan sebagai cadangan.',
                          style: TextStyle(
                            color: AppColors.brown,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ...List.generate(_displaySteps.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.maroon,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  _displaySteps[index],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                const SizedBox(height: 20),
                _sectionTitle('Tips Memasak'),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.maroon,
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(widget.cookingTip)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openingVideo ? null : _openVideo,
                    icon: _openingVideo
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.play_circle_outline),
                    label: const Text('Lihat Video Memasak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.maroon,
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
