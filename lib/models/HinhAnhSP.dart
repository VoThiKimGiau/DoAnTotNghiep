class HinhAnhSP {
  final String maHinhAnh;
  final String lienKetURL;

  HinhAnhSP({
    required this.maHinhAnh,
    required this.lienKetURL,
  });

  factory HinhAnhSP.fromJson(Map<String, dynamic> json) {
    return HinhAnhSP(
      maHinhAnh: json['maHinh'] as String,
      lienKetURL: json['duongDan'] as String,
    );
  }
}
