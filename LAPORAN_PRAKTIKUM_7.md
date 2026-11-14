# Laporan Praktikum 7: Memahami CRUD Flutter secara Bertahap

**Mata Kuliah:** Pemrograman Mobile  
**Nama Mahasiswa:** Tegar Rifa'i  
**NIM:** 240111014  
**Program Studi:** Informatika  
**Repositori GitHub:** [https://github.com/tgrf-v/Mobile_TugasPert9](https://github.com/tgrf-v/Mobile_TugasPert9)  
**Lingkungan Pengembangan:** Flutter SDK 3.47.5, Dart 3.13.4, Windows 11 / Chrome Web  

---

## 1. Ringkasan Eksekutif Praktikum

Praktikum ini berfokus pada pemahaman siklus hidup state dan implementasi operasi dasar *Create, Read, Update, Delete* (CRUD) serta pencarian data dinamis pada framework Flutter tanpa melibatkan database eksternal. Seluruh manipulasi data dilakukan di memori utama (RAM) menggunakan struktur data `List<Map<String, String>>`. Pendekatan yang diterapkan mengikuti alur *Understand → Implement → Verify* melalui 7 tahapan modular dan 4 tantangan individual.

---

## 2. Rincian Implementasi dan Refleksi Tiap Tahap

### Tahap 0: Kerangka Aplikasi

- **Fokus Kode:** Mengenal arsitektur dasar Flutter: fungsi `main()`, widget root `MaterialApp`, pemisahan `StatefulWidget` (`MahasiswaPage`) dan kelas `State` (`_MahasiswaPageState`), struktur tata letak `Scaffold`, serta metode `build()`.
- **Modifikasi Mandiri:** Mengubah judul AppBar menjadi `Praktikum 7 - Pemrograman Mobile` sebagai penanda identitas modul kuliah.
- **Refleksi Wajib:**
  1. *Apa beda `MyWidget` (`StatefulWidget`) dan `State<MyWidget>`?*  
     `StatefulWidget` adalah konfigurasi widget yang bersifat immutable (tidak dapat diubah setelah dibuat). Setiap kali terjadi render ulang, instance widget dapat dibuat baru oleh framework. Sebaliknya, objek `State` bersifat mutable dan persisten sepanjang lifecycle widget di widget tree. Objek `State` inilah yang menampung variabel data, fungsi logika bisnis, dan memicu pembaruan antarmuka via `setState()`.
  2. *Mengapa `build()` dapat dijalankan ulang?*  
     Flutter bekerja secara deklaratif dan reaktif. Metode `build()` didesain ringan (*cheap to execute*) dan dipanggil ulang setiap kali kondisi state internal berubah (`setState()`), terjadi perubahan dependensi inherited widget (seperti `MediaQuery` atau `Theme`), atau widget induk membangun ulang pohon antarmuka.

---

### Tahap 1: Inisialisasi Data

- **Fokus Kode:** Mendefinisikan struktur data penyimpanan sementara di RAM menggunakan `final List<Map<String, String>> mahasiswa` serta variabel auto-increment `nextId`.
- **Modifikasi Mandiri:** Menambahkan record mahasiswa ketiga secara langsung pada tahap inisialisasi awal:
  ```dart
  {'id': '3', 'nim': '240111014', 'nama': 'Tegar Rifa\'i', 'prodi': 'Informatika'}
  ```
  dan menyesuaikan nilai awal `nextId = 4`.
- **Refleksi Wajib:**
  1. *Di mana data berada?*  
     Data tersimpan di memori kerja (RAM) perangkat sebagai bagian dari instance objek `_MahasiswaPageState`.
  2. *Apa yang terjadi bila aplikasi dijalankan ulang dari awal?*  
     Seluruh data runtime yang ditambahkan atau diubah akan hilang dan kembali ke kondisi awal (3 record bawaan). Hal ini terjadi karena aplikasi belum terhubung ke penyimpanan persisten (seperti SQLite, Hive, atau SharedPreferences).

---

### Tahap 2: Menampilkan Data (READ)

- **Fokus Kode:** Mengganti body statis dengan widget `ListView.builder` yang membaca `itemCount` dari panjang data list dan memanfaatkan `itemBuilder` untuk menghasilkan widget `Card` dan `ListTile` secara *on-demand* (lazy rendering).
- **Modifikasi Mandiri:** Mengubah format `subtitle` pada `ListTile` agar menampilkan Program Studi sebelum NIM:
  ```dart
  subtitle: Text('${item['prodi']} | ${item['nim']}'),
  ```
- **Refleksi Wajib:**
  1. *Apa hubungan `itemCount`, `index`, dan `mahasiswa[index]`?*  
     `itemCount` memberitahu Flutter berapa total elemen yang perlu disiapkan. Parameter `index` adalah nomor urut baris yang sedang dirender di layar (mulai dari 0 sampai `itemCount - 1`). Sedangkan `mahasiswa[index]` adalah operasi indexing untuk mengambil data map spesifik pada urutan tersebut guna diikat (*binding*) ke widget tampilan.

---

### Tahap 3: Menambah Data (CREATE)

- **Fokus Kode:** Menambahkan tombol aksi mengambang (`FloatingActionButton`) dan fungsi asinkron `tambahData()`. Fungsi ini membuka `MahasiswaForm` via `showDialog()`. Form dirancang sebagai `StatefulWidget` terpisah dengan `GlobalKey<FormState>`, validasi input, serta siklus hidup `TextEditingController` yang ditutup aman pada `dispose()`.
- **Modifikasi Mandiri:** Memperjelas form dengan label terstruktur, menambahkan helper text, dan validasi duplikasi NIM terhadap record yang sudah terdaftar.
- **Refleksi Wajib:**
  1. *Mengapa `showDialog` menggunakan `await`?*  
     Karena pembukaan dialog adalah proses interaktif non-blocking. Eksekusi fungsi harus ditangguhkan sampai pengguna selesai mengisi form dan menutup dialog (baik menekan tombol Simpan maupun Batal) yang mengembalikan hasil melalui `Navigator.pop(context, data)`.
  2. *Apa fungsi `mounted`?*  
     `mounted` adalah properti boolean bawaan `State` yang menandakan apakah widget masih terpasang aktif pada pohon widget. Pengecekan `if (!mounted) return;` wajib dilakukan setelah operasi asinkron (`await`) sebelum memanggil `setState()` untuk mencegah runtime exception jika pengguna telah meninggalkan halaman saat proses asinkron berlangsung.

---

### Tahap 4: Mengubah Data (UPDATE)

- **Fokus Kode:** Membuat fungsi `ubahData(Map<String, String> dipilih)` yang membuka kembali `MahasiswaForm` dengan membawa nilai awal (`dataAwal`). Penentuan record sasaran menggunakan metode `indexWhere((m) => m['id'] == dipilih['id'])` lalu memperbarui record tanpa mengganti nilai `id`. Tombol ubah disematkan pada properti `trailing` di setiap `ListTile`.
- **Modifikasi Mandiri:** Mengubah nama data mahasiswa kedua dan memverifikasi bahwa field `nim` tetap terjaga utuh.
- **Refleksi Wajib:**
  1. *Mengapa menggunakan `indexWhere` berdasarkan `id` lebih aman daripada menggunakan indeks tampilan?*  
     Indeks tampilan pada ListView dapat berubah drastis ketika data disaring (filter pencarian) atau diurutkan (sorting). Jika update dilakukan berdasar indeks tampilan, perubahan akan menimpa record yang salah pada list utama. Penggunaan `id` unik menjamin bahwa objek yang diperbarui di memori selalu tepat sasaran.

---

### Tahap 5: Menghapus Data (DELETE)

- **Fokus Kode:** Implementasi `hapusData(Map<String, String> dipilih)` yang memunculkan `AlertDialog` konfirmasi. Jika pengguna menekan Hapus (`setuju == true`), record dihapus dari RAM via `mahasiswa.removeWhere((m) => m['id'] == dipilih['id'])` di dalam `setState()`.
- **Modifikasi Mandiri:** Menguji kedua skenario: menekan "Batal" (data tetap utuh) dan menekan "Hapus" (data terhapus dari tampilan dan list utama).
- **Refleksi Wajib:**
  1. *Mengapa operasi hapus perlu konfirmasi?*  
     Untuk mencegah kehilangan data akibat sentuhan yang tidak disengaja (*accidental touch*) pada perangkat layar sentuh bergerak.
  2. *Apa yang dihapus sebenarnya, widget atau item List?*  
     Yang dihapus secara aktual adalah elemen Map di dalam objek `List` pada RAM. Hilangnya baris kartu dari antarmuka merupakan akibat dari `setState()` yang memicu render ulang `ListView.builder` berdasarkan list yang telah diperbarui.

---

### Tahap 6: Pencarian Data (SEARCH)

- **Fokus Kode:** Menambahkan `TextField` pencarian di atas list dengan event `onChanged`, variabel penampung `keyword`, dan getter `dataTampil`. Metode `where()` dipadukan dengan `toLowerCase()` untuk memastikan pencarian bersifat *case-insensitive* pada nama maupun NIM.
- **Modifikasi Mandiri:** Mencari kata kunci dengan variasi huruf kapital (contoh: `sItI`), mengedit data hasil pencarian, lalu menghapus filter pencarian untuk memastikan perubahan tersimpan permanen pada list utama.
- **Refleksi Wajib:**
  1. *Mengapa pencarian tidak langsung menghapus elemen dari List asli?*  
     Pencarian adalah proyeksi visual sementara (*read-only filter*). Jika list asli dimodifikasi untuk keperluan pencarian, data lain yang tidak sesuai kata kunci akan terhapus permanen dari memori aplikasi.

---

## 3. Implementasi 4 Fitur Tantangan Individual

Empat tantangan individual telah diselesaikan secara tuntas dan terintegrasi pada `lib/main.dart`:

### Tantangan A: Validasi Numerik dan Panjang Minimal NIM
- **Solusi:** Menambahkan validasi Regular Expression `RegExp(r'^\d+$')` dan pengecekan panjang karakter `v.length >= 6` pada `validator` input NIM di `MahasiswaForm`.
- **Kasus Uji:**
  1. Input `ABC123` -> Menolak dengan pesan "NIM harus berisi hanya angka".
  2. Input `12345` -> Menolak dengan pesan "NIM harus minimal 6 digit angka".
  3. Input `240111014` -> Diterima sebagai data valid.

### Tantangan B: Tampilan Penghitung Jumlah Data Tersimpan dan Ditemukan
- **Solusi:** Menyematkan baris status informasi di bawah form pencarian menggunakan widget `Row` yang menampilkan total data tersimpan di RAM (`mahasiswa.length`) dan jumlah data yang sedang lolos filter pencarian (`dataTampil.length`).
- **Kasus Uji:**
  1. Kondisi awal tanpa filter -> `Tersimpan: 3 | Ditemukan: 3`.
  2. Pencarian kata kunci `siti` -> `Tersimpan: 3 | Ditemukan: 1`.
  3. Pencarian kata kunci tidak ditemukan (`xyz`) -> `Tersimpan: 3 | Ditemukan: 0` disertai warna peringatan visual dan pesan informatif di tengah layar.

### Tantangan C: Pengurutan Nama A–Z yang Aman
- **Solusi:** Menambahkan variabel state `urutkanAZ` beserta tombol toggle ikon pada `AppBar`. Pengurutan dilakukan di dalam getter `dataTampil` menggunakan fungsi `sort()` tanpa mengubah susunan elemen pada list induk `mahasiswa`.
- **Kasus Uji:**
  1. Tombol urut ditekan -> Urutan nama berubah menjadi terurut alfabetis.
  2. Mengedit salah satu record pada mode terurut -> Nilai terbarui pada ID yang sesuai tanpa merusak struktur data list asli.

### Tantangan D: Fitur Pembatalan Penghapusan (Undo) via SnackBarAction
- **Solusi:** Menyimpan indeks posisi asli (`indexAsli`) dan data yang dihapus (`itemTerhapus`) sebelum pemanggilan `removeWhere()`. Setelah penghapusan, ditampilkan `SnackBar` dengan aksi "BATALKAN" yang memanggil `mahasiswa.insert(indexAsli.clamp(0, mahasiswa.length), itemTerhapus)`.
- **Kasus Uji:**
  1. Menghapus record Andi -> Muncul SnackBar "Data 'Andi' dihapus" dengan tombol "BATALKAN".
  2. Menekan tombol "BATALKAN" -> Record Andi kembali muncul pada posisi semula dengan status terverifikasi lengkap.

---

## 4. Tahap 7: Hasil Pengujian Mandiri dan Verifikasi Sistem

Pengujian dijalankan melalui pengujian interaktif antarmuka dan otomatisasi *widget testing* (`flutter test`). Seluruh 10 kasus uji standar modul praktikum dinyatakan **Lulus (100% PASS)**:

| No | Skenario Pengujian | Hasil yang Diharapkan | Hasil Aktual | Status |
|:--:|:---|:---|:---|:---:|
| 1 | Dua/Tiga data awal dimuat | Seluruh kartu mahasiswa awal muncul di layar | 3 kartu (Andi, Siti, Tegar Rifa'i) tampil sempurna | **LULUS** |
| 2 | Submit form dengan NIM kosong | Form menolak dan memunculkan pesan validasi | Pesan "NIM wajib diisi" muncul di bawah field | **LULUS** |
| 3 | Input NIM duplikat (misal 2026001) | Form menolak penyimpanan | Pesan "NIM sudah digunakan oleh mahasiswa lain" muncul | **LULUS** |
| 4 | Tambah data dengan NIM unik | Dialog tertutup dan kartu baru bertambah | Kartu bertambah dan indikator tersimpan naik | **LULUS** |
| 5 | Mengubah nama mahasiswa | Hanya nama record target yang berubah, NIM tetap | Nama diperbarui tanpa mengubah NIM record | **LULUS** |
| 6 | Membatalkan dialog hapus data | Data tidak terhapus dan tetap berada di daftar | Record tetap utuh pada posisinya | **LULUS** |
| 7 | Mengonfirmasi dialog hapus data | Record target terhapus dari daftar | Record dihapus dan indikator tersimpan berkurang | **LULUS** |
| 8 | Pencarian kata kunci campuran `sItI` | Pencarian tidak membedakan huruf besar/kecil | Hanya record "Siti" yang ditampilkan | **LULUS** |
| 9 | Mengubah data hasil pencarian | Pembaruan tersimpan pada record asli di memori | Record asli terbarui saat pencarian dikosongkan | **LULUS** |
| 10 | Memulai ulang aplikasi dari awal | State kembali ke inisialisasi awal | Data runtime kembali ke data default RAM | **LULUS** |

---

## 5. Catatan Penggunaan AI yang Bertanggung Jawab

Dalam pengerjaan tugas ini, kecerdasan buatan dimanfaatkan sebagai asisten telaah kode dan perancangan kasus uji dengan batasan verifikasi mandiri yang ketat:

1. **Pertanyaan yang Diajukan ke AI:**
   - *Bagaimana struktur regex Dart terbaik untuk membatasi input hanya angka dengan panjang minimal tertentu pada `TextFormField`?*
   - *Bagaimana teknik pencegahan `RangeError` saat mengembalikan item yang dihapus melalui `SnackBarAction` jika pengguna telah melakukan filter atau penambahan item lain sebelum tombol batalkan ditekan?*

2. **Evaluasi Saran AI (Diterima vs Ditolak):**
   - **Saran Diterima:** Penggunaan `indexAsli.clamp(0, mahasiswa.length)` pada operasi `insert()` fitur undo. Saran ini sangat tepat guna mencegah error indeks di luar jangkauan jika panjang list berubah secara dinamis.
   - **Saran Ditolak:** AI sempat mengusulkan penggunaan pustaka pihak ketiga seperti `flutter_bloc` atau `provider` untuk mengelola state pencarian dan CRUD. Saran ini ditolak karena melanggar prinsip *Ponytail* (anti-bloat) dan keluar dari batas modul praktikum dasar yang berfokus pada pemahaman native `setState()`.

3. **Bukti Pengujian Kode:**
   Semua saran yang diadaptasi telah divalidasi melalui eksekusi berkas `test/widget_test.dart` dengan output:
   ```text
   00:03 +7: All tests passed!
   ```

---

## 6. Lembar Refleksi Akhir

1. **Inisialisasi:**  
   Penyimpanan dilakukan menggunakan variabel `final List<Map<String, String>> mahasiswa` di dalam kelas `_MahasiswaPageState`. Tipe data `List` merepresentasikan koleksi terurut yang dinamis, sedangkan `Map<String, String>` menyimpan atribut berpasangan *key-value* (`id`, `nim`, `nama`, `prodi`). `nextId` bertipe integer digunakan untuk menghasilkan identitas numerik unik auto-increment.
2. **Read (Menampilkan Data):**  
   Widget `ListView.builder` ditempatkan di dalam widget `Expanded` agar menempati sisa ruang vertikal layar secara fleksibel. Properti `itemCount` dihubungkan dengan panjang `dataTampil`, sedangkan `itemBuilder` membaca elemen map berdasarkan indeks untuk dikonstruksi menjadi widget `Card` dan `ListTile`.
3. **Create (Menambah Data):**  
   Aliran data berawal dari interaksi klik pada `FloatingActionButton`, yang memicu dialog formulir `MahasiswaForm`. Saat tombol Simpan ditekan dan validasi form terpenuhi, data dikembalikan ke pemanggil via `Navigator.pop(context, map)`. Nilai tersebut diberi ID baru melalui `${nextId++}`, lalu digabungkan dan dimasukkan ke list via `mahasiswa.add()` di dalam blok `setState()`.
4. **Update (Mengubah Data):**  
   Identitas `id` dipilih sebagai kunci pencarian record (`indexWhere((m) => m['id'] == dipilih['id'])`) karena nilai ID bersifat persisten dan unik. Penggunaan indeks ListView berisiko tinggi menghasilkan salah ubah record ketika urutan tampilan telah terdistorsi oleh filter pencarian atau sorting.
5. **Delete (Menghapus Data):**  
   Aliran penghapusan diawali dari penekanan ikon tong sampah, menampilkan `AlertDialog` konfirmasi modal. Jika pengguna menyetujui, fungsi mengeksekusi `mahasiswa.removeWhere((m) => m['id'] == dipilih['id'])` di dalam `setState()`, yang langsung memicu pembaruan pohon widget antarmuka.
6. **Search (Pencarian Data):**  
   Pencarian memanfaatkan getter `dataTampil` yang menerapkan metode `where()` pada list utama tanpa memutasi koleksi asli. Dengan cara ini, data asli di RAM tetap terjaga utuh meskipun tampilan antarmuka disaring secara dinamis sesuai kata kunci yang dimasukkan pengguna.
7. **Refleksi AI:**  
   Saran AI mengenai penanganan *safe index insertion* menggunakan fungsi `.clamp()` terbukti sangat membantu stabilitas aplikasi. Di sisi lain, rekomendasi AI untuk memasang dependensi state management eksternal harus diverifikasi dan ditolak demi menjaga kode tetap ringkas, bersih, dan tepat sasaran.
8. **Testing:**  
   Pengujian komprehensif membuktikan bahwa seluruh fungsi CRUD dasar, validasi form, sorting, pencarian case-insensitive, dan mekanisme undo berjalan tanpa kendala teknis (10/10 skenario pengujian berstatus lulus).
