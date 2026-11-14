# Mobile_TugasPert9: Flutter CRUD Bertahap

Repositori tugas mata kuliah **Pemrograman Mobile** yang mengimplementasikan operasi dasar *Create, Read, Update, Delete* (CRUD) serta pencarian dinamis berbasis state in-memory (RAM) pada framework Flutter.

## Identitas Mahasiswa
- **Nama:** Tegar Rifa'i
- **NIM:** 240111014
- **Program Studi:** Informatika
- **Praktikum:** Praktikum 7 - CRUD Flutter Bertahap

---

## Tahapan Implementasi

1. **Tahap 0: Kerangka Aplikasi** (`main()`, `MaterialApp`, `StatefulWidget`, `State`, `Scaffold`, `build()`).
2. **Tahap 1: Inisialisasi Data** (Penyimpanan RAM `List<Map<String, String>> mahasiswa` dan auto-increment `nextId`).
3. **Tahap 2: Menampilkan Data (READ)** (`ListView.builder` dengan lazy rendering dan modifikasi format subtitle prodi sebelum NIM).
4. **Tahap 3: Menambah Data (CREATE)** (`FloatingActionButton`, `showDialog`, `MahasiswaForm` dengan `FormState` dan validasi).
5. **Tahap 4: Mengubah Data (UPDATE)** (`ubahData()` berbasis pencarian unik `id` menggunakan `indexWhere`).
6. **Tahap 5: Menghapus Data (DELETE)** (`hapusData()` dengan `AlertDialog` konfirmasi modal dan `removeWhere`).
7. **Tahap 6: Pencarian Data (SEARCH)** (Filter *case-insensitive* `keyword` dan getter `dataTampil`).
8. **Tahap 7 & Verifikasi:** Otomatisasi pengujian antarmuka melalui `test/widget_test.dart` (10/10 kasus uji lolos 100%).

---

## 4 Fitur Tantangan Individual

- **Tantangan A:** Validasi input NIM wajib numerik murni dan minimal 6 digit (`RegExp(r'^\d+$')`).
- **Tantangan B:** Indikator penghitung ganda (Total tersimpan vs Total data hasil filter).
- **Tantangan C:** Pengurutan daftar nama secara alfabetis (A–Z) melalui toggle AppBar tanpa memutasi urutan list asli di memori.
- **Tantangan D:** Fitur pembatalan penghapusan (*undo*) menggunakan `SnackBarAction` yang mengembalikan item ke indeks asalnya secara aman.

---

## Cara Menjalankan Proyek

1. **Jalankan Aplikasi:**
   ```bash
   flutter run
   # Atau jalankan di Chrome:
   flutter run -d chrome
   ```

2. **Jalankan Pengujian Otomatis:**
   ```bash
   flutter test
   ```

3. **Dokumentasi Laporan:**
   - Format Markdown: [LAPORAN_PRAKTIKUM_7.md](LAPORAN_PRAKTIKUM_7.md)
   - Format Word: `Laporan_Praktikum_7_Flutter_CRUD_Bertahap_TegarRifai.docx`
