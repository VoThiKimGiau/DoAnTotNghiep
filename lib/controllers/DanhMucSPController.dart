import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:http/http.dart' as http;

class DanhMucSPController{
  Future<List<DanhMucSP>> fetchDanhMucSP() async {
    String baseUrl = 'http://${IpConfig.ipConfig}/api/danhmucsp';

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

  Future<List<SanPham>> fetchProductByCategory(String maDM) async{
    String baseUrl = 'http://${IpConfig.ipConfig}/api/sanpham/byCategory?maDanhMuc=$maDM';

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
}