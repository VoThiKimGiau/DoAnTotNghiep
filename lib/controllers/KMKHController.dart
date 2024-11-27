import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';

import '../models/KMKH.dart';
import 'package:http/http.dart' as http;

import 'NhanVienController.dart';
class KMKHController {
  final String baseUrl = "${IpConfig.ipConfig}api/kmkh";

  // Lấy danh sách khuyến mãi của khách hàng
  Future<List<KMKH>> getPromotionsByCustomer(String maKH) async {
    final response = await http.get(Uri.parse('$baseUrl/khachhang/$maKH'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => KMKH.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load promotions for customer $maKH");
    }
  }

  Future<List<KMKH>> getAll() async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.get(Uri.parse('$baseUrl'),headers: {"Content-Type": "application/json",'Authorization': 'Bearer $token'},);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => KMKH.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load promotions ");
    }
  }

  // Thêm khuyến mãi mới cho khách hàng
  Future<KMKH> addCustomerPromotion(KMKH kmkh) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    print('debug'+json.encode(kmkh.toJson()));
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {"Content-Type": "application/json",'Authorization': 'Bearer $token'},
      body: json.encode(kmkh.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return KMKH.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to add promotion for customer");
    }
  }

  Future<void> updateKhuyenMaiKhachHang(String khachHangId, String khuyenMaiId, KMKH kmkh) async {
    final String url = '$baseUrl/$khachHangId/$khuyenMaiId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(kmkh.toJson()),
      );

      if (response.statusCode == 200) {
        KMKH updatedKMKH = KMKH.fromJson(jsonDecode(response.body));
        print('Cập nhật thành công: ${updatedKMKH.toJson()}');
      } else {
        print('Lỗi: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
    }
  }

  Future<int?> getSoLuong(String khachHangId, String khuyenMaiId) async {
    final String url = '$baseUrl/laySL/$khachHangId/$khuyenMaiId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        print('Lỗi: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      // Xử lý ngoại lệ
      print('Đã xảy ra lỗi: $e');
      return null;
    }
  }

  Future<void> deleteKhuyenMaiKhachHang(String khachHangId, String khuyenMaiId) async {
    final String url = '$baseUrl/$khachHangId/$khuyenMaiId';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 204) {
        print('Xóa thành công');
      } else {
        print('Lỗi: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
    }
  }
}
