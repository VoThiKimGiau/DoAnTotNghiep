import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:http/http.dart' as http;

class SanPhamController {
  final String baseUrl = '${IpConfig.ipConfig}api/sanpham/search';

  Future<String?> getProductNameByMaSP(String maSP) async {
    final response = await http.get(Uri.parse('$baseUrl?maSP=$maSP'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse[
          'tenSP']; // Adjust the key according to your actual response
    } else {
      throw Exception('Failed to load product');
    }
  }

  final String baseUrl_AllSP =
      '${IpConfig.ipConfig}api/sanpham?page=1&size=10';

  Future<List<SanPham>> fetchSanPham() async {
    final response = await http.get(
      Uri.parse(baseUrl_AllSP),
    );

    if (response.statusCode == 200) {
      // Decode the response
      final Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      // Access the 'items' list within the 'data' map
      final List<dynamic> items = jsonResponse['data']['items'];

      // Map the items to SanPham objects
      return items.map((item) => SanPham.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load SanPham data');
    }
  }

  Future<SanPham> getProductByMaSP(String maSP) async {
    final response = await http.get(Uri.parse('$baseUrl?maSP=$maSP'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      return SanPham.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load product by MaSP');
    }
  }

  Future<List<SanPham>> getProductByCategory(String maDanhMuc) async {
    const String baseUrl_Cate =
        '${IpConfig.ipConfig}api/sanpham/byCategory';
    final response = await http.get(Uri.parse('$baseUrl_Cate?maDanhMuc=$maDanhMuc'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => SanPham.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load product by category');
    }
  }

  Future<SanPham?> updateProduct(String id, SanPham updatedSanPham) async {
    final String apiUrl = '${IpConfig.ipConfig}api/sanpham/update/$id';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedSanPham.toJson()),
    );

    if (response.statusCode == 200) {
      return SanPham.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to update product: ${response.statusCode}');
      return null;
    }
  }
}
