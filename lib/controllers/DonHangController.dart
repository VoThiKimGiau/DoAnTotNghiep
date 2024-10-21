import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/DonHang.dart';

class DonHangController {
  Future<List<DonHang>> fetchDonHang(String? maKH) async {
    final response = await http.get(
      Uri.parse('http://${IpConfig.ipConfig}/api/donhang/byCustomer?maKH=$maKH'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((donHang) => DonHang.fromJson(donHang)).toList();
    } else {
      throw Exception('Failed to load DonHang');
    }
  }
  Future<DonHang> fetchDetailDonHang(String? maDH) async {
    final response = await http.get(
      Uri.parse('http://${IpConfig.ipConfig}/api/donhang/$maDH'),
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return DonHang.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load DonHang');
    }
  }
}
