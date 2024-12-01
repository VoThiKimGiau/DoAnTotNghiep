class ChiTietSP {
  final String maCTSP;
  final String maSP;
  final String maKichCo;
  final String maMau;
  final double giaBan;
  final String maHinhAnh;
  final String maNCC;
  final int slKho;

  ChiTietSP(
      {required this.maCTSP,
      required this.maSP,
      required this.maKichCo,
      required this.maMau,
      required this.giaBan,
      required this.maHinhAnh,
      required this.maNCC,
      required this.slKho});

  factory ChiTietSP.fromJson(Map<String, dynamic> json) {
    return ChiTietSP(
        maCTSP: json['maCTSP'] ?? '',
        maSP: json['maSanPham'] ?? '',
        maKichCo: json['maKichCo'] ?? '',
        maMau: (json['maMau'] ?? ''),
        giaBan: json['giaBan'] ?? 0,
        maHinhAnh: json['maHinhAnh'] ?? '',
        maNCC: json['maNCC'] ?? '',
        slKho: json['slKho'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'maCTSP': maCTSP,
      'maSanPham': maSP,
      'maKichCo': maKichCo,
      'maMau': maMau,
      'giaBan': giaBan,
      'maHinhAnh': maHinhAnh,
      'maNCC': maNCC,
      'slKho': slKho,
    };
  }
}
