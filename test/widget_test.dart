import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tugas_pert9/main.dart';

void main() {
  testWidgets('Uji 1: Verifikasi data awal ditampilkan', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MahasiswaPage()));
    await tester.pumpAndSettle();

    expect(find.text('Andi'), findsOneWidget);
    expect(find.text('Siti'), findsOneWidget);
    expect(find.text('Tegar Rifa\'i'), findsOneWidget);
    expect(find.text('Tersimpan: 3'), findsOneWidget);
  });

  testWidgets('Uji 2 & Tantangan A: Validasi input form (kosong, duplikat, < 6 digit, non-angka)', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MahasiswaPage()));
    await tester.pumpAndSettle();

    // Buka form tambah
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    // 1. Submit form kosong -> validasi aktif
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('NIM wajib diisi'), findsOneWidget);

    // 2. Input non-angka
    await tester.enterText(find.widgetWithText(TextFormField, 'Nomor Induk Mahasiswa (NIM)'), 'ABC123');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('NIM harus berisi hanya angka'), findsOneWidget);

    // 3. Input angka < 6 digit
    await tester.enterText(find.widgetWithText(TextFormField, 'Nomor Induk Mahasiswa (NIM)'), '12345');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('NIM harus minimal 6 digit angka'), findsOneWidget);

    // 4. Input NIM duplikat
    await tester.enterText(find.widgetWithText(TextFormField, 'Nomor Induk Mahasiswa (NIM)'), '2026001');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('NIM sudah digunakan oleh mahasiswa lain'), findsOneWidget);

    // Tutup dialog
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
  });

  testWidgets('Uji 4: Tambah mahasiswa baru berhasil', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MahasiswaPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nomor Induk Mahasiswa (NIM)'), '240111999');
    await tester.enterText(find.widgetWithText(TextFormField, 'Nama Lengkap Mahasiswa'), 'Budi Santoso');
    await tester.enterText(find.widgetWithText(TextFormField, 'Program Studi'), 'Sistem Informasi');

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Tersimpan: 4'), findsOneWidget);
  });

  testWidgets('Uji 5: Ubah nama mahasiswa berhasil', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MahasiswaPage()));
    await tester.pumpAndSettle();

    // Tap icon edit pertama (Andi)
    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();

    expect(find.text('Ubah Data Mahasiswa'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Nama Lengkap Mahasiswa'), 'Andi Pratama');

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Andi Pratama'), findsOneWidget);
    expect(find.textContaining('2026001'), findsOneWidget);
  });

  testWidgets('Uji 6, 7 & Tantangan D: Batal hapus, konfirmasi hapus, dan undo via SnackBar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MahasiswaPage()));
    await tester.pumpAndSettle();

    // 1. Uji batal hapus
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();
    expect(find.text('Hapus data?'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Andi'), findsOneWidget);

    // 2. Uji konfirmasi hapus
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Andi'), findsNothing);
    expect(find.text('Data "Andi" dihapus'), findsOneWidget);

    // 3. Uji Tantangan D: Tekan BATALKAN (Undo)
    await tester.tap(find.text('BATALKAN'));
    await tester.pumpAndSettle();
    expect(find.text('Andi'), findsOneWidget);
  });

  testWidgets('Uji 8 & Tantangan B: Pencarian case-insensitive dan counter data', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MahasiswaPage()));
    await tester.pumpAndSettle();

    // Cari dengan variasi huruf kapital "sItI"
    await tester.enterText(find.byType(TextField), 'sItI');
    await tester.pumpAndSettle();

    expect(find.text('Siti'), findsOneWidget);
    expect(find.text('Andi'), findsNothing);
    expect(find.text('Ditemukan: 1'), findsOneWidget);
    expect(find.text('Tersimpan: 3'), findsOneWidget);

    // Bersihkan filter
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    expect(find.text('Andi'), findsOneWidget);
    expect(find.text('Ditemukan: 3'), findsOneWidget);
  });

  testWidgets('Tantangan C: Sorting A-Z', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MahasiswaPage()));
    await tester.pumpAndSettle();

    // Tap icon sort A-Z di AppBar
    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.sort_by_alpha), findsOneWidget);
  });
}
