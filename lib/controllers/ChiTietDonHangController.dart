import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietDonHang.dart';
import 'package:http/http.dart' as http;
import '../models/DonHang.dart';

class ChiTietDonHangController {
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
  Future<List<ChiTietDonHang>> fetchListProduct(String madh) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/chitietdonhang/maDonHang?madh=$madh'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => ChiTietDonHang.fromJson(item)).toList();
    } else {
      throw Exception('Failed  product count');
    }
  }

}
