import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/KhuyenMai.dart';
import 'NhanVienController.dart';

class KhuyenMaiController {
  final String apiUrl = "${IpConfig.ipConfig}api/khuyenmai";

  // Lấy danh sách tất cả các khuyến mãi
  Future<List<KhuyenMai>> getAllKhuyenMai() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => KhuyenMai.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load promotions');
    }
  }

  // Lấy thông tin chi tiết của một khuyến mãi
  Future<KhuyenMai> getKhuyenMaiById(String maKM) async {
    final response = await http.get(Uri.parse('$apiUrl/$maKM'));

    if (response.statusCode == 200) {
      return KhuyenMai.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load promotion details');
    }
  }

  // Tạo mới một chương trình khuyến mãi
  Future<KhuyenMai> createKhuyenMai(KhuyenMai khuyenMai) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: json.encode(khuyenMai.toJson()),
    );

    if (response.statusCode == 200) {
      return KhuyenMai.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create promotion');
    }
  }

  // Cập nhật thông tin một khuyến mãi
  Future<KhuyenMai> updateKhuyenMai(String maKM, KhuyenMai updatedKhuyenMai) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$maKM'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedKhuyenMai.toJson()),
    );

    if (response.statusCode == 200) {
      return KhuyenMai.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update promotion');
    }
  }

  // Xóa một khuyến mãi
  Future<void> deleteKhuyenMai(String maKM) async {
    final response = await http.delete(Uri.parse('$apiUrl/$maKM'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete promotion');
    }
  }
}
