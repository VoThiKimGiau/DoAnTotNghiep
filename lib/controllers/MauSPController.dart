import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/MauSP.dart';
import 'package:http/http.dart' as http;
class MauSPController{

  Future<String> layTenMauByMaMau(String maMau) async {
    try {
      final response = await http.get(
        Uri.parse('${IpConfig.ipConfig}api/mau-sps/$maMau'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Sử dụng utf8.decode với bodyBytes
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = json.decode(decodedBody);

        // Thêm xử lý đặc biệt cho tên màu nếu cần
        String tenMau = jsonResponse['tenMau']?.toString() ?? '';
        return tenMau;
      } else {
        throw Exception('Failed to load color name: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in layTenMauByMaMau: $e');
      throw Exception('Error getting color name: $e');
    }
  }

  Future<int> fetchProductCount(String madh) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/chitietdonhang/count?madh=$madh'),
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load product count');
    }
  }

  Future<MauSP> layMauTheoMa(String maMau) async {
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/mau-sps/$maMau'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
      json.decode(utf8.decode(response.bodyBytes));

      return MauSP.fromJson(jsonResponse);
    } else {
      print('Error: ${response.statusCode}'); // In ra mã lỗi
      throw Exception("Lỗi khi lấy màu sản phẩm");
    }
  }

  Future<List<MauSP>> fetchAllMauSP() async {
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/mau-sps'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => MauSP.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load MauSPs');
    }
  }

  Future<MauSP> addMauSP(MauSP mauSP) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/mau-sps'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(mauSP.toJson()),
    );

    if (response.statusCode == 201) {
      return MauSP.fromJson(json.decode(response.body));
    } else {
      throw Exception('Thêm màu sản phẩm thất bại: ${response.statusCode}');
    }
  }

  Future<MauSP> updateMauSP(String maMau, MauSP mauSP) async {
    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/mau-sps/$maMau'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(mauSP.toJson()),
    );

    if (response.statusCode == 200) {
      return MauSP.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Màu sản phẩm không tồn tại');
    } else {
      throw Exception('Cập nhật màu sản phẩm thất bại: ${response.statusCode}');
    }
  }
}