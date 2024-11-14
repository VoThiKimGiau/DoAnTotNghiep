import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/models/SPYeuThich.dart';
import 'package:http/http.dart' as http;

import '../config/IpConfig.dart';
import '../models/SanPham.dart';

class SPYeuThichController {

  Future<List<SPYeuThich>> fetchSPYeuThichByKH(String? maKH) async {
    String baseUrl =
        '${IpConfig.ipConfig}api/sp-yeu-thich/khach-hang/$maKH';

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => SPYeuThich.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load SPYeuThich data');
    }
  }

  Future<SPYeuThich?> themSPYeuThich(SPYeuThich spYeuThich) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/sp-yeu-thich'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(spYeuThich.toJson()),
    );

    if (response.statusCode == 201) {
      return SPYeuThich.fromJson(json.decode(response.body));
    } else {
      // Xử lý lỗi
      print('Failed to create: ${response.statusCode}');
      return null;
    }
  }

  Future<bool> xoaSPYeuThich(String khachHang, String sanPham) async {
    final response = await http.delete(
      Uri.parse('${IpConfig.ipConfig}api/sp-yeu-thich/$khachHang/$sanPham'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true; // Xóa thành công
    } else {
      // Xử lý lỗi
      print('Failed to delete: ${response.statusCode}');
      return false; // Không xóa thành công
    }
  }
}
