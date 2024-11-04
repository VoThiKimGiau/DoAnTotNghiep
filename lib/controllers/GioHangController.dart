import 'dart:convert';

import '../config/IpConfig.dart';
import 'package:http/http.dart' as http;

class GioHangController{
  Future<String> getMaGHByMaKH(String? maKH) async {
    final response = await http.get(
      Uri.parse(
          '${IpConfig.ipConfig}api/giohang?khachHang=$maKH'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse['maGioHang'];
    } else {
      throw Exception('Failed to load mã giỏ hàng từ mã khách hàng');
    }
  }
}