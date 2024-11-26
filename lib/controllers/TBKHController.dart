import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';

import '../models/TBKH.dart';
import 'package:http/http.dart'as http;

import 'NhanVienController.dart';
class TBKHController{
  Future<List<TBKH>> getAllTBKH() async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();


    if (token == null) {
      throw Exception("Token không tồn tại");
    }
      final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/tbkh'),
        headers: {"Content-Type": "application/json",'Authorization':'Bearer $token'},);

      if (response.statusCode == 200) {
        final List<dynamic> tbkhList = jsonDecode(response.body);
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => TBKH.fromJson(json)).toList();
      }
      else
        throw Exception("Loi tai danh sach thong bao khach hang");
  }
  Future<TBKH> createTBKH(TBKH tbkh) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}/api/tbkh'),
      headers: {"Content-Type": "application/json",'Authorization':'Bearer $token'},
      body: jsonEncode(tbkh.toJson()),
    );

    if (response.statusCode == 201) {
      return TBKH.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create TBKH');
    }
  }
  Future<TBKH> updateTBKH(TBKH updatedTBKH) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/tbkh'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(updatedTBKH.toJson()),
    );

    if (response.statusCode == 200) {
      return TBKH.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update TBKH');
    }
  }


}