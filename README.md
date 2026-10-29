# JajanYuk – Resep Dessert


- **Nama:** Mursiyah Dwi Erlena
- **NIM:** 240605110010
- **Kelas:** F
- **Mata Kuliah:** Mobile Programming Praktikum
- **Dosen Pengampu:** Khadijah Fahmi Hayati Holle, S.Kom., M.Kom

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
├── models/
├── pages/
├── services/
├── widgets/
└── main.dart
```

Aplikasi menggunakan API untuk mengambil data resep dan layanan MyMemory untuk menerjemahkan langkah memasak. Favorit disimpan secara lokal. Fitur publikasi resep, penyimpanan profil permanen, dan autentikasi belum terhubung ke backend.

