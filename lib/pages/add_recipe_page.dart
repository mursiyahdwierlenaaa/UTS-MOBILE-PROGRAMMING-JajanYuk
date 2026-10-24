
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_colors.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  final _durationController = TextEditingController(text: '45');
  final _servingsController = TextEditingController(text: '6');
  final _videoController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? _selectedCategory;
  File? _selectedImage;
  bool _isPickingImage = false;

  final List<String> _categories = [
    'Cake',
    'Cookies',
    'Brownies',
    'Pudding',
    'Donat',
    'Roti',
    'Dessert',
    'Minuman',
    'Lainnya',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _durationController.dispose();
    _servingsController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    setState(() => _isPickingImage = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image != null && mounted) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Foto belum dapat dipilih. Coba lagi.');
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.maroon,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;

    if (_selectedCategory == null) {
      _showMessage('Silakan pilih kategori resep.');
      return false;
    }

    final duration = int.tryParse(_durationController.text.trim());
    final servings = int.tryParse(_servingsController.text.trim());

    if (duration == null || duration <= 0) {
      _showMessage('Durasi harus berupa angka lebih dari 0.');
      return false;
    }

    if (servings == null || servings <= 0) {
      _showMessage('Porsi harus berupa angka lebih dari 0.');
      return false;
    }

    return true;
  }

  void _previewRecipe() {
    if (!_validateForm()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipePreviewPage(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory!,
          ingredients: _ingredientsController.text.trim(),
          steps: _stepsController.text.trim(),
          duration: _durationController.text.trim(),
          servings: _servingsController.text.trim(),
          videoUrl: _videoController.text.trim(),
          image: _selectedImage,
        ),
      ),
    );
  }

  void _publishRecipe() {
    if (!_validateForm()) return;

    // Penyimpanan permanen belum dihubungkan ke database.
    _showMessage(
      'Formulir valid. Fitur penyimpanan resep belum terhubung.',
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.brown,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.brown.withValues(alpha: 0.55),
        fontSize: 14,
      ),
      filled: true,
      fillColor: AppColors.cream,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(
          color: AppColors.lightBrown.withValues(alpha: 0.6),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(
          color: AppColors.lightBrown.withValues(alpha: 0.6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(
          color: AppColors.maroon,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: AppColors.brown,
            fontSize: 14,
          ),
          decoration: _inputDecoration(hint),
          validator: requiredField
              ? (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi.';
            }
            return null;
          }
              : null,
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _isPickingImage ? null : _pickImage,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.lightBrown),
        ),
        child: _selectedImage == null
            ? Row(
          children: [
            const SizedBox(width: 18),
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.lightBrown.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _isPickingImage
                    ? Icons.hourglass_empty
                    : Icons.camera_alt_outlined,
                color: AppColors.maroon,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unggah foto resep',
                    style: TextStyle(
                      color: AppColors.maroon,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'JPG atau PNG\nPilih foto dari galeri',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  onPressed: () {
                    setState(() => _selectedImage = null);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.cream,
                  ),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.maroon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tambah Resep',
                  style: TextStyle(
                    color: AppColors.maroon,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bagikan kreasi dessert terbaikmu '
                      'dengan komunitas JajanYuk.',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.lightBrown.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brown.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImagePicker(),
                      const SizedBox(height: 24),
                      _buildTextField(
                        label: 'Nama resep',
                        controller: _nameController,
                        hint: 'Contoh: Tiramisu Klasik',
                      ),
                      const SizedBox(height: 22),
                      _buildTextField(
                        label: 'Deskripsi',
                        controller: _descriptionController,
                        hint: 'Ceritakan rasa dan keunikan resep...',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 22),
                      _buildLabel('Kategori'),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        decoration: _inputDecoration('Pilih kategori'),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.brown,
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(
                                color: AppColors.brown,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Kategori wajib dipilih.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      _buildTextField(
                        label: 'Bahan dan jumlah',
                        controller: _ingredientsController,
                        hint: 'Tulis satu bahan per baris\n'
                            '200 g tepung\n'
                            '2 butir telur',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 22),
                      _buildTextField(
                        label: 'Langkah memasak',
                        controller: _stepsController,
                        hint: 'Tulis satu langkah per baris\n'
                            'Panaskan oven...\n'
                            'Campurkan bahan...',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Durasi (menit)',
                              controller: _durationController,
                              hint: '45',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'Porsi',
                              controller: _servingsController,
                              hint: '6',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _buildTextField(
                        label: 'Tautan video (opsional)',
                        controller: _videoController,
                        hint: 'YouTube atau TikTok',
                        requiredField: false,
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _previewRecipe,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.maroon,
                                side: const BorderSide(
                                  color: AppColors.maroon,
                                ),
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text('Pratinjau'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: _publishRecipe,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.maroon,
                                foregroundColor: AppColors.cream,
                                elevation: 0,
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'Publikasikan',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class RecipePreviewPage extends StatelessWidget {
  final String name;
  final String description;
  final String category;
  final String ingredients;
  final String steps;
  final String duration;
  final String servings;
  final String videoUrl;
  final File? image;

  const RecipePreviewPage({
    super.key,
    required this.name,
    required this.description,
    required this.category,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.servings,
    required this.videoUrl,
    required this.image,
  });

  Widget _section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.maroon,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content.isEmpty ? '-' : content,
            style: const TextStyle(
              color: AppColors.brown,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Pratinjau Resep'),
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.maroon,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.file(
                image!,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 18),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.maroon,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$category • $duration menit • $servings porsi',
            style: const TextStyle(color: AppColors.brown),
          ),
          _section('Deskripsi', description),
          _section('Bahan dan jumlah', ingredients),
          _section('Langkah memasak', steps),
          if (videoUrl.isNotEmpty) _section('Tautan video', videoUrl),
        ],
      ),
    );
  }
}
