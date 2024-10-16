import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
class SanPhamController{
  final String baseUrl = 'http://${IpConfig.ipConfig}/api/sanpham/search';

  Future<String?> getProductNameByMaSP(String maSP) async {
    final response = await http.get(Uri.parse('$baseUrl?maSP=$maSP'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['tenSP']; // Adjust the key according to your actual response
    } else {
      throw Exception('Failed to load product');
    }
  }
}