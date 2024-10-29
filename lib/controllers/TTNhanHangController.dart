// lib/controllers/tt_nhan_hang_controller.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/TTNhanHang.dart';

class TTNhanHangController {
  final String baseUrl = 'http://${IpConfig.ipConfig}/api/ttnhanhang';

  // Lấy thông tin địa chỉ nhận hàng theo mã khách hàng
  Future<List<TTNhanHang>> fetchTTNhanHangByCustomer(String? maKH) async {
    final response =
        await http.get(Uri.parse('$baseUrl/byCustomer?maKH=$maKH'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TTNhanHang.fromJson(json)).toList();
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(
          'Failed to load TTNhanHang. Status code: ${response.statusCode}');
    }
  }

  // Lấy thông tin địa chỉ nhận hàng theo mã địa chỉ
  Future<TTNhanHang?> fetchTTNhanHang(String maTTNH) async {
    final response = await http.get(Uri.parse('$baseUrl/$maTTNH'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return TTNhanHang.fromJson(data);
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(
          'Failed to load TTNhanHang. Status code: ${response.statusCode}');
    }
  }
}
