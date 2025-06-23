import 'package:flutter/material.dart';
import 'package:keungan/models/transaksi_model.dart';

class DetailPage extends StatelessWidget {
  final Transaksi transaksi;

  const DetailPage({Key? key, required this.transaksi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(transaksi.timestamp);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaksi.imageUrl != null && transaksi.imageUrl!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    transaksi.imageUrl!,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _buildLabelValue("Judul :", transaksi.deskripsi, fontSize: 18),
            _buildLabelValue(
              "Jenis :",
              transaksi.tipe == "pemasukan" ? "Pemasukan" : "Pengeluaran",
            ),
            _buildLabelValue(
              "Tanggal :",
              "${date.day} ${_bulan(date.month)} ${date.year}",
            ),
            _buildLabelValue(
              "Jumlah :",
              "Rp. ${transaksi.jumlah.toStringAsFixed(0)}",
            ),
            _buildLabelValue(
              "Deskripsi :",
              transaksi.deskripsi,
              fontSize: 16,
              minHeight: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValue(
    String label,
    String value, {
    double fontSize = 14,
    int? maxLines,
    double? minHeight,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF508C9B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight ?? 0),
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  height: 1.5,
                ),
                maxLines: maxLines,
                overflow:
                    maxLines != null
                        ? TextOverflow.ellipsis
                        : TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _bulan(int bulan) {
    const namaBulan = [
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
    return namaBulan[bulan];
  }
}
