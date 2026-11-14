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
  final List<Map<String, String>> mahasiswa = [
    {'id': '1', 'nim': '2026001', 'nama': 'Andi', 'prodi': 'Informatika'},
    {'id': '2', 'nim': '2026002', 'nama': 'Siti', 'prodi': 'Informatika'},
    {'id': '3', 'nim': '240111014', 'nama': 'Tegar Rifa\'i', 'prodi': 'Informatika'},
  ];
  int nextId = 4;

  // TAHAP 3: CREATE. Form mengembalikan data baru.
  Future<void> tambahData() async {
    final hasil = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => MahasiswaForm(dataSudahAda: mahasiswa),
    );
    if (!mounted || hasil == null) return;
    setState(() {
      mahasiswa.add({'id': '${nextId++}', ...hasil});
    });
  }

  // TAHAP 4: UPDATE berdasarkan id, BUKAN indeks ListView.
  Future<void> ubahData(Map<String, String> dipilih) async {
    final hasil = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => MahasiswaForm(
        dataAwal: dipilih,
        dataSudahAda: mahasiswa,
      ),
    );
    if (!mounted || hasil == null) return;
    final index = mahasiswa.indexWhere((m) => m['id'] == dipilih['id']);
    if (index < 0) return;
    setState(() {
      mahasiswa[index] = {'id': dipilih['id']!, ...hasil};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Praktikum 7 - Pemrograman Mobile')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Data tersimpan: ${mahasiswa.length}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mahasiswa.length,
              itemBuilder: (context, index) {
                final item = mahasiswa[index];
                return Card(
                  child: ListTile(
                    title: Text(item['nama']!),
                    subtitle: Text('${item['prodi']} | ${item['nim']}'),
                    trailing: IconButton(
                      tooltip: 'Ubah Data',
                      icon: const Icon(Icons.edit),
                      onPressed: () => ubahData(item),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: tambahData,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

// Form dipisahkan menjadi widget agar controller memiliki lifecycle yang benar.
class MahasiswaForm extends StatefulWidget {
  final Map<String, String>? dataAwal;
  final List<Map<String, String>> dataSudahAda;

  const MahasiswaForm({super.key, this.dataAwal, required this.dataSudahAda});

  @override
  State<MahasiswaForm> createState() => _MahasiswaFormState();
}

class _MahasiswaFormState extends State<MahasiswaForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nim;
  late final TextEditingController nama;
  late final TextEditingController prodi;

  @override
  void initState() {
    super.initState();
    nim = TextEditingController(text: widget.dataAwal?['nim'] ?? '');
    nama = TextEditingController(text: widget.dataAwal?['nama'] ?? '');
    prodi = TextEditingController(text: widget.dataAwal?['prodi'] ?? '');
  }

  @override
  void dispose() {
    nim.dispose();
    nama.dispose();
    prodi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dataAwal == null ? 'Tambah Data Mahasiswa' : 'Ubah Data Mahasiswa'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nim,
                decoration: const InputDecoration(
                  labelText: 'Nomor Induk Mahasiswa (NIM)',
                  hintText: 'Contoh: 2026003',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'NIM wajib diisi';
                  final sudahAda = widget.dataSudahAda.any((m) =>
                    m['nim'] == v && m['id'] != widget.dataAwal?['id']);
                  if (sudahAda) return 'NIM sudah digunakan oleh mahasiswa lain';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nama,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap Mahasiswa',
                  hintText: 'Contoh: Budi Santoso',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama lengkap wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: prodi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  hintText: 'Contoh: Informatika',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Program studi wajib diisi' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            Navigator.pop(context, {
              'nim': nim.text.trim(),
              'nama': nama.text.trim(),
              'prodi': prodi.text.trim(),
            });
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
