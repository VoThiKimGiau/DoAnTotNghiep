class ChiTietDoiTra {
  String maDoiTra;
  String maCTSP;
  double gia;
  int soluong;

  ChiTietDoiTra({
    required this.maDoiTra,
    required this.maCTSP,
    required this.gia,
    required this.soluong,
  });

  Map<String, dynamic> toJson() {
    return {
      'maDoiTra': maDoiTra,
      'maCTSP': maCTSP,
      'gia': gia,
      'soluong': soluong,
    };
  }

  factory ChiTietDoiTra.fromJson(Map<String, dynamic> json) {
    return ChiTietDoiTra(
      maDoiTra: json['maDoiTra'],
      maCTSP: json['maCTSP'],
      gia: json['gia'],
      soluong: json['soluong'],
    );
  }
}
