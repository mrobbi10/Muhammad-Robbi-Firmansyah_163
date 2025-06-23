import 'package:flutter/material.dart';
import 'package:keungan/models/transaksi_model.dart';
import 'package:keungan/screens/tambah_transaksi_page.dart';
import 'package:keungan/services/transaksi_services.dart';
import 'package:keungan/screens/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransaksiService _service = TransaksiService();
  List<Transaksi> _transaksiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransaksi();
  }

  Future<void> fetchTransaksi() async {
    final data = await _service.fetchTransaksi();
    setState(() {
      _transaksiList = data;
      _isLoading = false;
    });
  }

  double get totalSaldo {
    double saldo = 0;
    for (var trx in _transaksiList) {
      if (trx.tipe == 'pemasukan') {
        saldo += trx.jumlah;
      } else {
        saldo -= trx.jumlah;
      }
    }
    return saldo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchTransaksi,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Saldo : Rp. ${totalSaldo.toStringAsFixed(0)}",
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _transaksiList.length,
                        itemBuilder: (context, index) {
                          final transaksi = _transaksiList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailPage(transaksi: transaksi),
                                ),
                              );
                            },
                            child: Container(
                              height: 120,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                color: const Color(0xFF508C9B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: index == 1
                                        ? Colors.pink
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      if (transaksi.imageUrl != null &&
                                          transaksi.imageUrl!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            transaksi.imageUrl!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              transaksi.deskripsi,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Text(
                                              transaksi.tipe == 'pemasukan'
                                                  ? 'Pemasukan'
                                                  : 'Pengeluaran',
                                              style: const TextStyle(
                                                  color: Colors.white70),
                                            ),
                                            Text(
                                              "Tanggal : ${_formatTanggal(transaksi.timestamp)}",
                                              style: const TextStyle(
                                                  color: Colors.white70),
                                            ),
                                            Text(
                                        "Rp. ${transaksi.jumlah.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const TambahTransaksiPage(),
    ),
  );

  if (result == true) {
    fetchTransaksi();
  }
},
        backgroundColor: const Color(0xFF201E43),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatTanggal(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    const bulan = [
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
      'Desember'
    ];
    return "${date.day} ${bulan[date.month]} ${date.year}";
  }
}
