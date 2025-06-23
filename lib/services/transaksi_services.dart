import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:keungan/models/transaksi_model.dart';

class TransaksiService {
  final String firebaseBaseUrl =
    'https://catatankeuangan-dceca-default-rtdb.firebaseio.com';


Future<List<Transaksi>> fetchTransaksi() async {
  final response = await http.get(Uri.parse('$firebaseBaseUrl/transaksi.json'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data == null) return [];

    List<Transaksi> transaksiList = (data as Map<String, dynamic>)
        .entries
        .map((e) => Transaksi.fromJson(e.value, e.key))
        .toList();
    transaksiList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return transaksiList;
  }

  return [];
}
  Future<void> addTransaksi(Transaksi transaksi) async {
    final response = await http.post(
      Uri.parse('$firebaseBaseUrl/transaksi.json'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(transaksi.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      transaksi.id = data['name']; 
    } else {
      throw Exception("Gagal menambahkan transaksi.");
    }
  }
  Future<void> updateTransaksi(Transaksi transaksi) async {
    if (transaksi.id == null) {
      throw Exception("ID transaksi tidak boleh null.");
    }

    final response = await http.patch(
      Uri.parse('$firebaseBaseUrl/transaksi/${transaksi.id}.json'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(transaksi.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal mengupdate transaksi.");
    }
  }
  Future<void> deleteTransaksi(String id) async {
    final response = await http.delete(
      Uri.parse('$firebaseBaseUrl/transaksi/$id.json'),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus transaksi.");
    }
  }
}
