class ChiTietGioHang {
  final String maGioHang;
  final String maCTSP;
  final int soLuong;
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
      'maGioHang': maGioHang,
      'maSanPham': maCTSP,
      'soLuong': soLuong,
      'gia': donGia,
    };
  }

  ChiTietGioHang copyWith({
    String? maGioHang,
    String? maCTSP,
    int? soLuong,
    double? donGia,
  }) {
    return ChiTietGioHang(
      maGioHang: maGioHang ?? this.maGioHang,
      maCTSP: maCTSP ?? this.maCTSP,
      soLuong: soLuong ?? this.soLuong,
      donGia: donGia ?? this.donGia,
    );
  }
}
