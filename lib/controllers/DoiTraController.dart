import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';

import '../models/ChiTietDoiTra.dart';
import '../models/DoiTra.dart';
import 'package:http/http.dart' as http;
class DoiTraController{
  final String baseUrl='${IpConfig.ipConfig}';
  Future<void> createDoiTra(DoiTra doiTra) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/doitra'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(doiTra.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create DoiTra');
    }
  }
  Future<void> createChiTietDoiTra(ChiTietDoiTra chiTietDoiTra) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/chitietdoitra'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(chiTietDoiTra.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create ChiTietDoiTra');
    }
  }
  Future<List<DoiTra>> getDoiTraList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/doitra'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => DoiTra.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load DoiTra list');
    }
  }

  // Lấy danh sách chi tiết đổi trả theo mã đổi trả
  Future<List<ChiTietDoiTra>> getChiTietDoiTra(String maDoiTra) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/chitietdoitra/$maDoiTra'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ChiTietDoiTra.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load ChiTietDoiTra list');
    }
  }
}