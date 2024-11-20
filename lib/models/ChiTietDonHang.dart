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
      donHang: json['madh'] ?? '',
      sanPham: json['mactsp'] ?? '',
      soLuong: json['soluong'] ?? 0,
      donGia: (json['dongia'] is num) ? json['dongia'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madh': donHang,
      'mactsp': sanPham,
      'soluong': soLuong,
    };
  }

}
