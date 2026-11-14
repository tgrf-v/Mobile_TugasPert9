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

  // TAHAP 6: Filter pencarian
  String keyword = '';

  // TANTANGAN C: Pengurutan data nama A-Z
  bool urutkanAZ = false;

  // Getter dataTampil (Filter + Tantangan B & C)
  List<Map<String, String>> get dataTampil {
    final q = keyword.trim().toLowerCase();
    final hasil = mahasiswa.where((m) =>
      m['nama']!.toLowerCase().contains(q) ||
      m['nim']!.toLowerCase().contains(q)
    ).toList();

    if (urutkanAZ) {
      hasil.sort((a, b) =>
        a['nama']!.toLowerCase().compareTo(b['nama']!.toLowerCase())
      );
    }
    return hasil;
  }

  // TAHAP 3: CREATE
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

  // TAHAP 4: UPDATE berdasarkan id
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

  // TAHAP 5 & TANTANGAN D: DELETE dengan konfirmasi + Undo via SnackBarAction
  Future<void> hapusData(Map<String, String> dipilih) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus data?'),
        content: Text('Hapus data mahasiswa ${dipilih['nama']} (NIM: ${dipilih['nim']})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (!mounted || setuju != true) return;

    final int indexAsli = mahasiswa.indexWhere((m) => m['id'] == dipilih['id']);
    final itemTerhapus = dipilih;

    setState(() => mahasiswa.removeWhere((m) => m['id'] == dipilih['id']));

    // Tantangan D: Fitur Undo pembatalan penghapusan
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data "${itemTerhapus['nama']}" dihapus'),
        action: SnackBarAction(
          label: 'BATALKAN',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              mahasiswa.insert(
                indexAsli.clamp(0, mahasiswa.length),
                itemTerhapus,
              );
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 7 - Pemrograman Mobile'),
        actions: [
          // Tantangan C: Toggle Sort A-Z
          IconButton(
            tooltip: urutkanAZ ? 'Urutan Default' : 'Urutkan Nama A-Z',
            icon: Icon(urutkanAZ ? Icons.sort_by_alpha : Icons.sort),
            onPressed: () => setState(() => urutkanAZ = !urutkanAZ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari nama atau NIM',
                hintText: 'Ketik nama atau NIM...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: keyword.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => keyword = ''),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => keyword = v),
            ),
          ),
          // Tantangan B: Tampilan jumlah total dan hasil pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tersimpan: ${mahasiswa.length}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Ditemukan: ${dataTampil.length}',
                  style: TextStyle(
                    color: dataTampil.isEmpty && keyword.isNotEmpty
                        ? Colors.red
                        : Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: dataTampil.isEmpty
                ? Center(
                    child: Text(
                      keyword.isEmpty
                          ? 'Belum ada data'
                          : 'Tidak ada mahasiswa sesuai "$keyword"',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: dataTampil.length,
                    itemBuilder: (context, index) {
                      final item = dataTampil[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text(item['nama']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item['prodi']} | ${item['nim']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Ubah Data',
                                icon: const Icon(Icons.edit),
                                onPressed: () => ubahData(item),
                              ),
                              IconButton(
                                tooltip: 'Hapus Data',
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => hapusData(item),
                              ),
                            ],
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
              // Tantangan A: Validasi NIM hanya angka & min 6 digit
              TextFormField(
                controller: nim,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nomor Induk Mahasiswa (NIM)',
                  hintText: 'Minimal 6 digit angka',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'NIM wajib diisi';
                  if (!RegExp(r'^\d+$').hasMatch(v)) {
                    return 'NIM harus berisi hanya angka';
                  }
                  if (v.length < 6) {
                    return 'NIM harus minimal 6 digit angka';
                  }
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
