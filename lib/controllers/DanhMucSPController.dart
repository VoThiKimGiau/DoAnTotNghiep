import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:http/http.dart' as http;

import 'NhanVienController.dart';

class DanhMucSPController {
  Future<List<DanhMucSP>> fetchDanhMucSP() async {
    String baseUrl = '${IpConfig.ipConfig}api/danhmucsp';

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => DanhMucSP.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load DanhMucSP data');
    }
  }

  Future<List<SanPham>> fetchProductByCategory(String? maDM) async {
    String baseUrl =
        '${IpConfig.ipConfig}api/sanpham/byCategory?maDanhMuc=$maDM';

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => SanPham.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Product By Category data');
    }
  }

  Future<String?> fetchTenDM(String? maDM) async {
    String baseUrl = '${IpConfig.ipConfig}api/danhmucsp/$maDM';

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse['tenDanhMuc'];
    } else {
      throw Exception('Failed to load DanhMucSP theo mã danh mục data');
    }
  }

  Future<DanhMucSP> getDanhMucById(String id) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/danhmucsp/$id'),
    );

    if (response.statusCode == 200) {
      return DanhMucSP.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 404) {
      throw Exception('Không tìm thấy danh mục với ID: $id');
    } else {
      throw Exception('Lỗi lấy danh mục: ${response.statusCode}');
    }
  }

  Future<DanhMucSP> addDanhMucSP(DanhMucSP danhMucSP) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/danhmucsp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(danhMucSP.toJson()),
    );

    if (response.statusCode == 201) {
      return DanhMucSP.fromJson(json.decode(response.body));
    } else {
      throw Exception('Thêm mới danh mục thất bại: ${response.statusCode}');
    }
  }

  Future<DanhMucSP> updateDanhMucSP(String id, DanhMucSP danhMucSP) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/danhmucsp/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(danhMucSP.toJson()),
    );

    if (response.statusCode == 200) {
      return DanhMucSP.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Danh mục không tồn tại');
    } else {
      throw Exception('Cập nhật danh mục thất bại: ${response.statusCode}');
    }
  }
}
