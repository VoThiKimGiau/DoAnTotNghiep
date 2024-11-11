import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';

import '../models/ChiTietDoiTra.dart';
import '../models/DoiTra.dart';
import 'package:http/http.dart' as http;
class DoiTraController{
  final String baseUrl='${IpConfig.ipConfig}';
  Future<DoiTra> createDoiTra(DoiTra doiTra) async {
    try {
      String jsonString = jsonEncode(doiTra.toJson());
      print(jsonString);
      final response = await http.post(
        Uri.parse('${baseUrl}api/doitra'),
        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode(doiTra.toJson()),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // If successful, parse the response body and return a DoiTra object
        return DoiTra.fromJson(jsonDecode(response.body));
      } else {
        // If the response was not successful, throw an error
        throw Exception('Failed to create DoiTra. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error in case of network or other issues
      print('Error creating DoiTra: $e');
      throw Exception('Error creating DoiTra');
    }
  }

  Future<void> createChiTietDoiTra(ChiTietDoiTra chiTietDoiTra) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/chitietdoitra'),
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