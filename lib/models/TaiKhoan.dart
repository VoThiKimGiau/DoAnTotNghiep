
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaiKhoan {
  final String tenTK;
  final String matKhau;
  final String? maNV;
  final String? maKH;
  final bool hoatDong;

  TaiKhoan({
    required this.tenTK,
    required this.matKhau,
    this.maNV,
    this.maKH,
    required this.hoatDong,
  });

  factory TaiKhoan.fromJson(Map<String, dynamic> json) {
    return TaiKhoan(
      tenTK: json['tenTK'],
      matKhau: json['matKhau'],
      maKH: json['maKH'],
      maNV: json['maNV'],
      hoatDong: bool.parse(json['hoatDong']),
    );
  }

  // Method to convert a Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'tenTK': tenTK,
      'matKhau': matKhau,
      'maKH': maKH,
      'maNV': maNV,
      'hoatDong': hoatDong,
    };
  }
}
