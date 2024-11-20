class ChiTietGioHang {
  final String maGioHang;
  final String maCTSP;
  late final int soLuong;
  final double donGia;

  ChiTietGioHang({
    required this.maGioHang,
    required this.maCTSP,
    required this.soLuong,
    required this.donGia,
  });

  factory ChiTietGioHang.fromJson(Map<String, dynamic> json) {
    return ChiTietGioHang(
      maGioHang: json['gioHang'] ?? '',
      maCTSP: json['sanPham'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      donGia: json['donGia'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gioHang': maGioHang,
      'sanPham': maCTSP,
      'soLuong': soLuong,
      'donGia': donGia,
    };
  }
}
