import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/KichCo.dart';
import 'package:http/http.dart' as http;

class KichCoController {
  Future<String> layTenKichCo(String maKichCo) async {
    final response =
        await http.get(Uri.parse('${IpConfig.ipConfig}api/kich-cos/$maKichCo'));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonRequeue = json.decode(responseBody);
      return jsonRequeue['tenKichCo'];
    } else
      throw Exception("Lỗi lấy tên kích cỡ ");
  }

  Future<KichCo> layKichCo(String maKichCo) async {
    final response =
        await http.get(Uri.parse('${IpConfig.ipConfig}api/kich-cos/$maKichCo'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));

      return KichCo.fromJson(jsonResponse);
    } else
      throw Exception("Lỗi lấy tên kích cỡ ");
  }

  Future<List<KichCo>> fetchAllKichCo() async {
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/kich-cos'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => KichCo.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load KichCos');
    }
  }

  Future<KichCo> addKichCo(KichCo kichCo) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/kich-cos'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(kichCo.toJson()),
    );

    if (response.statusCode == 201) {
      return KichCo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Thêm kích cỡ thất bại: ${response.statusCode}');
    }
  }

  Future<KichCo> updateKichCo(String maKichCo, KichCo kichCo) async {
    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/kich-cos/$maKichCo'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(kichCo.toJson()),
    );

    if (response.statusCode == 200) {
      return KichCo.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Kích cỡ không tồn tại');
    } else {
      throw Exception('Cập nhật kích cỡ thất bại: ${response.statusCode}');
    }
  }
}
