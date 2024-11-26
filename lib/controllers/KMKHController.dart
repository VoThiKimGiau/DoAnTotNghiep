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

  // Thêm khuyến mãi mới cho khách hàng
  Future<KMKH> addCustomerPromotion(KMKH kmkh) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
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
}
