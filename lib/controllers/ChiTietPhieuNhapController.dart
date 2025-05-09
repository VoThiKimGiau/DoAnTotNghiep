import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietPhieuNhap.dart';
import 'package:http/http.dart' as http;

import 'NhanVienController.dart';

class ChiTietPhieuNhapController{
  Future<List<ChiTietPhieuNhap>> layDanhSachChiTietPhieuNhap(String maPhieu) async
  {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }


    String endpoint = "";
    if (maPhieu.length > 0) {
      endpoint = "api/chitietphieunhap?maPhieu=$maPhieu";
    }
    else {
      endpoint = "api/chitietphieunhap";
    }
    final response = await http.get(
        Uri.parse('${IpConfig.ipConfig}' + endpoint),headers: {
    'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => (ChiTietPhieuNhap.fromJson(item)))
          .toList();
    }
    else {
      throw Exception("Khong the tai chi tiet pn");
    }
  }
  Future<ChiTietPhieuNhap> themChiTietPhieuNhap(ChiTietPhieuNhap chiTietPhieuNhap) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/chitietphieunhap'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(chiTietPhieuNhap.toJson()),
    );

    if (response.statusCode == 201) {
      return ChiTietPhieuNhap.fromJson(json.decode(response.body));
    } else {
      throw Exception("Không thể thêm chi tiết phiếu nhập");
    }
  }
  Future<List<ChiTietPhieuNhap>> themNhieuChiTietPhieuNhap(List<ChiTietPhieuNhap> danhSachChiTiet) async {
    List<ChiTietPhieuNhap> ketQua = [];
    for (ChiTietPhieuNhap chiTiet in danhSachChiTiet) {
      try {
        ChiTietPhieuNhap chiTietMoi = await themChiTietPhieuNhap(chiTiet);
        ketQua.add(chiTietMoi);
      } catch (e) {
        print("Lỗi khi thêm chi tiết phiếu nhập: $e");
      }
    }
    return ketQua;
  }


}