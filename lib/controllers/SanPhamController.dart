import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhanVienController.dart';
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

  Future<int> fetchAllSanPham() async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/sanpham'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data']['totalCount']; // Trả về giá trị totalCount
    } else {
      throw Exception('Failed to load data');
    }
  }

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
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final String apiUrl = '${IpConfig.ipConfig}api/sanpham/update/$id';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(updatedSanPham.toJson()),
    );

    if (response.statusCode == 200) {
      return SanPham.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to update product: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  Future<SanPham> addSanPham(SanPham sanPham) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/sanpham/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(sanPham.toJson()),
    );

    if (response.statusCode == 200) {
      return SanPham.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Dữ liệu sản phẩm không hợp lệ: ${response.body}');
    } else {
      throw Exception('Thêm sản phẩm thất bại: ${response.statusCode}');
    }
  }
}
