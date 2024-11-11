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
      'madoitra': maDoiTra,
      'mactsp': maCTSP,
      'gia': gia,
      'soluong': soluong,
    };
  }

  factory ChiTietDoiTra.fromJson(Map<String, dynamic> json) {
    return ChiTietDoiTra(
      maDoiTra: json['madoitra'],
      maCTSP: json['mactsp'],
      gia: json['gia'],
      soluong: json['soluong'],
    );
  }
}
