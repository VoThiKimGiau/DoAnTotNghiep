import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/IpConfig.dart';
import '../models/TaiKhoan.dart';

class TaiKhoanController {
  final String baseUrl = 'http://${IpConfig.ipConfig}/api/taikhoan/login';

  Future<List<TaiKhoan>> fetchTK(String tenTK, String matKhau) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'tenDangNhap': tenTK,
        'matKhau': matKhau,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => TaiKhoan.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load TaiKhoan data');
    }
  }
}