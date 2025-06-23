class Transaksi {
  String? id;
  String deskripsi;
  double jumlah;
  String tipe;
  int timestamp; 
  String? imageUrl; 

  Transaksi({
    this.id,
    required this.deskripsi,
    required this.jumlah,
    required this.tipe,
    required this.timestamp,
    this.imageUrl,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json, String id) {
    return Transaksi(
      id: id,
      deskripsi: json['deskripsi'],
      jumlah: json['jumlah']?.toDouble() ?? 0.0,
      tipe: json['tipe'],
      timestamp: json['timestamp'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deskripsi': deskripsi,
      'jumlah': jumlah,
      'tipe': tipe,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
    };
  }
}
