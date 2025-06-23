import 'package:flutter/material.dart';
import 'package:keungan/models/transaksi_model.dart';
import 'package:keungan/services/transaksi_services.dart';

class TambahTransaksiPage extends StatefulWidget {
  const TambahTransaksiPage({super.key});

  @override
  State<TambahTransaksiPage> createState() => _TambahTransaksiPageState();
}

class _TambahTransaksiPageState extends State<TambahTransaksiPage> {
  final _formKey = GlobalKey<FormState>();
  final TransaksiService _service = TransaksiService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  String _tipe = 'pemasukan';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Placeholder Foto
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  "assets/images/dummy.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              _buildLabel("Title :"),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Judul transaksi"),
                validator:
                    (value) =>
                        value!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),

              const SizedBox(height: 12),

              // Jenis Transaksi
              _buildLabel("Jenis Transaksi :"),
              DropdownButtonFormField<String>(
                value: _tipe,
                items: const [
                  DropdownMenuItem(
                    value: "pemasukan",
                    child: Text("Pemasukan"),
                  ),
                  DropdownMenuItem(
                    value: "pengeluaran",
                    child: Text("Pengeluaran"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _tipe = value);
                },
                style: const TextStyle(color: Colors.white),
                dropdownColor: const Color(0xFF508C9B),
                decoration: _inputDecoration("Pilih tipe"),
              ),

              const SizedBox(height: 12),

              // Tanggal
              _buildLabel("Tanggal :"),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  decoration: _inputBoxDecoration(),
                  child: Text(
                    "${_selectedDate.day} ${_bulan(_selectedDate.month)} ${_selectedDate.year}",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Jumlah
              _buildLabel("Jumlah :"),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Masukkan jumlah"),
                validator:
                    (value) =>
                        value!.isEmpty ? "Jumlah tidak boleh kosong" : null,
              ),

              const SizedBox(height: 12),

              // Deskripsi
              _buildLabel("Deskripsi :"),
              TextFormField(
                controller: _deskripsiController,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                minLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: _inputDecoration("Detail catatan"),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF201E43),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: _simpanTransaksi,
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: const Color(0xFF508C9B),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );

  BoxDecoration _inputBoxDecoration() => BoxDecoration(
    color: const Color(0xFF508C9B),
    borderRadius: BorderRadius.circular(8),
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _simpanTransaksi() async {
    if (_formKey.currentState!.validate()) {
      final transaksi = Transaksi(
        deskripsi: _titleController.text,
        jumlah: double.tryParse(_jumlahController.text) ?? 0,
        tipe: _tipe,
        timestamp: _selectedDate.millisecondsSinceEpoch,
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIr_WtlJ8X6VrJiyDcxVRPReOME7GyeMLsLw&s",
      );

      await _service.addTransaksi(transaksi);
      Navigator.pop(context, true);
    }
  }

  String _bulan(int bulan) {
    const bulanIndo = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return bulanIndo[bulan];
  }
}
