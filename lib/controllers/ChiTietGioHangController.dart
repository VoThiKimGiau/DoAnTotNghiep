import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:http/http.dart' as http;
import '../models/ChiTietGioHang.dart';

class ChiTietGioHangController {
  // Lấy số lượng sản phẩm trong giỏ hàng
  Future<int> fetchProductCount(String maGioHang) async {
    final response = await http.get(
      Uri.parse(
          'http://${IpConfig.ipConfig}/api/chitietgiohang/count?maGioHang=$maGioHang'),
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load product count');
    }
  }

  // Lấy danh sách sản phẩm trong giỏ hàng
  Future<List<ChiTietGioHang>> fetchListProduct(String maGioHang) async {
    final response = await http.get(
      Uri.parse(
          'http://${IpConfig.ipConfig}/api/chitietgiohang?maGioHang=$maGioHang'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => ChiTietGioHang.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load product list');
    }
  }

  Future<ChiTietGioHang> themChiTietGioHang(ChiTietGioHang chiTietGioHang) async {
    final response = await http.post(
      Uri.parse('http://${IpConfig.ipConfig}/api/chitietgiohang'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode(chiTietGioHang.toJson()),
    );

    if (response.statusCode == 200) {
      return ChiTietGioHang.fromJson(json.decode(response.body));
    } else {
      throw Exception("Không thể thêm chi tiết giỏ hàng");
    }
  }
}
