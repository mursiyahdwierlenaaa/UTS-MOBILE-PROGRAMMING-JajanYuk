
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../services/favorite_service.dart';
import 'favorite_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileName = 'Mursiyah Dwi Erlena';
  String profileUsername = '@mursiyahdwierlena';

  // Data sementara untuk tampilan profil.
  int totalRecipes = 0;
  final int totalFollowers = 12;

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: profileName);
    final usernameController = TextEditingController(
      text: profileUsername.replaceFirst('@', ''),
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cream,
          title: const Text(
            'Edit Profil',
            style: TextStyle(
              color: AppColors.maroon,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixText: '@',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: AppColors.cream,
              ),
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    usernameController.text.trim().isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, true);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        profileName = nameController.text.trim();
        profileUsername =
        '@${usernameController.text.trim().replaceAll('@', '')}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui.'),
        ),
      );
    }

    nameController.dispose();
    usernameController.dispose();
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritePage(),
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cream,
          title: const Text(
            'Keluar dari Akun',
            style: TextStyle(
              color: AppColors.maroon,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari halaman profil?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Ya, Keluar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fitur akun belum terhubung dengan sistem login.',
          ),
        ),
      );
    }
  }

  Widget _buildStat({
    required String number,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: AppColors.maroon,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.brown,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 4,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE8DCCF),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.brown,
              size: 26,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.maroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.maroon,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,

      // Halaman Profil merupakan halaman utama.
      // Tidak menggunakan tombol panah kembali.
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: AppColors.maroon,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: AnimatedBuilder(
        animation: FavoriteService.instance,
        builder: (context, child) {
          final totalFavorites =
              FavoriteService.instance.favorites.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto profil dan identitas.
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: const Color(0xFFF7EDE0),
                        child: CircleAvatar(
                          radius: 49,
                          backgroundColor: AppColors.maroon,
                          child: Text(
                            profileName.isNotEmpty
                                ? profileName[0].toUpperCase()
                                : 'M',
                            style: const TextStyle(
                              color: AppColors.cream,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        profileName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.maroon,
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        profileUsername,
                        style: const TextStyle(
                          color: AppColors.brown,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: _editProfile,
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 19,
                        ),
                        label: const Text('Edit Profil'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.maroon,
                          side: const BorderSide(
                            color: Color(0xFFD1B2A9),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Statistik pengguna.
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFE8DCCF),
                      ),
                      bottom: BorderSide(
                        color: Color(0xFFE8DCCF),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildStat(
                        number: '$totalRecipes',
                        label: 'Resep',
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: const Color(0xFFE8DCCF),
                      ),
                      _buildStat(
                        number: '$totalFavorites',
                        label: 'Disukai',
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: const Color(0xFFE8DCCF),
                      ),
                      _buildStat(
                        number: '$totalFollowers',
                        label: 'Pengikut',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Resep buatan pengguna.
                const Text(
                  'Resep Buatanku',
                  style: TextStyle(
                    color: AppColors.maroon,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 26,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E6DA),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Belum ada resep yang kamu publikasikan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.brown,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fitur tambah dan publikasi resep '
                                    'belum tersedia.',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Tambah resep pertama',
                          style: TextStyle(
                            color: AppColors.maroon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Menu profil.
                _buildMenu(
                  icon: Icons.favorite_border_rounded,
                  title: 'Resep yang Disukai',
                  onTap: _openFavorites,
                ),
                _buildMenu(
                  icon: Icons.logout_rounded,
                  title: 'Keluar dari Akun',
                  onTap: _logout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
