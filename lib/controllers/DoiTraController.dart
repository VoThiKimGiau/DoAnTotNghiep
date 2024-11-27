import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';

import '../models/ChiTietDoiTra.dart';
import '../models/DoiTra.dart';
import 'package:http/http.dart' as http;

import 'NhanVienController.dart';
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
      Uri.parse('${baseUrl}api/doitra'),
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
      Uri.parse('${baseUrl}api/chitietdoitra/$maDoiTra'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ChiTietDoiTra.fromJson(data)).toList();

    } else {
      throw Exception('Failed to load ChiTietDoiTra list');
    }
  }
  Future<DoiTra> updateDoiTra(String maDoiTra, DoiTra updatedDoiTra) async {
    try {
      NhanVienController nhanVienController=NhanVienController();
      String? token = await nhanVienController.getToken();

      // Nếu không có token, throw một exception
      if (token == null) {
        throw Exception("Token không tồn tại");
      }
      // Encode đối tượng DoiTra thành JSON
      String jsonString = jsonEncode(updatedDoiTra.toJson());
      print("Request Body: $jsonString");

      // Gửi yêu cầu PUT tới API
      final response = await http.put(
        Uri.parse('${baseUrl}api/doitra/$maDoiTra'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonString,
      );

      // Kiểm tra phản hồi từ API
      if (response.statusCode == 200) {
        // Nếu thành công, trả về đối tượng DoiTra đã được cập nhật
        return DoiTra.fromJson(jsonDecode(response.body));
      } else {
        // Nếu thất bại, ném ra một ngoại lệ với thông tin chi tiết
        throw Exception(
            'Failed to update DoiTra. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi trong trường hợp gặp sự cố mạng hoặc lỗi khác
      print('Error updating DoiTra: $e');
      throw Exception('Error updating DoiTra');
    }
  }
}