# JajanYuk – Resep Dessert


- **Nama:** Mursiyah Dwi Erlena
- **NIM:** 240605110010
- **Mata Kuliah:** Mobile Programming


## Deskripsi
**JajanYuk** merupakan aplikasi resep dessert berbasis Flutter yang membantu pengguna menjelajahi resep, melihat bahan dan langkah memasak, serta menyimpan resep favorit. Aplikasi menggunakan API TheMealDB sebagai sumber data resep.

## Fitur Utama

1. **Beranda:** Menampilkan banner, kategori, dan rekomendasi dessert.
2. **Daftar Resep:** Menampilkan, mencari, dan memfilter resep.
3. **Detail Resep:** Menampilkan gambar, bahan, takaran, langkah memasak, terjemahan, dan tautan video jika tersedia.
4. **Favorit:** Menyimpan resep yang disukai menggunakan `SharedPreferences`.
5. **Tambah Resep:** Menyediakan formulir, pemilihan gambar, validasi, dan pratinjau resep.
6. **Profil:** Menampilkan dan mengubah informasi profil sementara.
7. **Navigasi:** Memudahkan perpindahan antarhalaman melalui menu navigasi bawah.

## Struktur Folder

```text
lib/
├── core/
│   └── app_colors.dart
├── models/
│   └── meal.dart
├── pages/
│   ├── add_recipe_page.dart
│   ├── favorite_page.dart
│   ├── home_page.dart
│   ├── main_navigation_page.dart
│   ├── profile_page.dart
│   ├── recipe_detail_page.dart
│   └── recipe_list_page.dart
├── services/
│   ├── favorite_service.dart
│   ├── meal_service.dart
│   └── translation_service.dart
├── widgets/
│   └── bottom_nav_bar.dart
└── main.dart
```

Teknologi yang Digunakan

Aplikasi menggunakan API untuk mengambil data resep dan layanan MyMemory untuk menerjemahkan langkah memasak. Favorit disimpan secara lokal. Fitur publikasi resep, penyimpanan profil permanen, dan autentikasi belum terhubung ke backend.

