import 'dart:convert';

class ChiTietDonHang {
  String donHang;
  String sanPham;
  int soLuong;
  double donGia;

  // Constructor
  ChiTietDonHang({
    required this.donHang,
    required this.sanPham,
    required this.soLuong,
    required this.donGia,
  });


  factory ChiTietDonHang.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHang(
      donHang: json['donHang'] ?? '',
      sanPham: json['mactsp'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      donGia: (json['donGia'] is num) ? json['donGia'].toDouble() : 0.0,
    );
  }

}
