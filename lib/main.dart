import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MahasiswaPage(),
));

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  // TAHAP 1: Inisialisasi data sementara di RAM.
  // Modifikasi mandiri: Menambahkan record mahasiswa baru (Tegar Rifa'i, NIM: 240111014).
  final List<Map<String, String>> mahasiswa = [
    {'id': '1', 'nim': '2026001', 'nama': 'Andi', 'prodi': 'Informatika'},
    {'id': '2', 'nim': '2026002', 'nama': 'Siti', 'prodi': 'Informatika'},
    {'id': '3', 'nim': '240111014', 'nama': 'Tegar Rifa\'i', 'prodi': 'Informatika'},
  ];
  int nextId = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Praktikum 7 - Pemrograman Mobile')),
      body: Center(
        child: Text(
          'Tahap 1: jumlah data awal = ${mahasiswa.length}',
        ),
      ),
    );
  }
}
