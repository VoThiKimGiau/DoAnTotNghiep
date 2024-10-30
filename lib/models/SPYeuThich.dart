class SPYeuThich {
  final String maKhachHang;
  final String maSanPham;

  SPYeuThich({
    required this.maKhachHang,
    required this.maSanPham,
  });

  factory SPYeuThich.fromJson(Map<String, dynamic> json) {
    return SPYeuThich(
      maKhachHang: json['khachHang'].trim(),
      maSanPham: json['sanPham'].trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'khachHang': maKhachHang,
      'sanPham': maSanPham,
    };
  }
}