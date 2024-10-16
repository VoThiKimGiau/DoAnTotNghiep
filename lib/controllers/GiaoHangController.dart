// lib/controllers/GiaoHangController.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/GiaoHang.dart';

class GiaoHangController {
  final String baseUrl = 'http://${IpConfig.ipConfig}/api/giaohang';

  Future<GiaoHang?> fetchGiaoHang(String donHang) async {
    final response = await http.get(Uri.parse('$baseUrl/donHang?donHang=$donHang'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return GiaoHang.fromJson(data);
    } else {
      throw Exception('Failed to load GiaoHang');
    }
  }
}
