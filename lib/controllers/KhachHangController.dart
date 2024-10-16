import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';

class KhachHangController {
  final String baseUrl = 'http://${IpConfig.ipConfig}/api/khachhang';

  Future<KhachHang?> getKhachHang(String maKH) async {
    final response = await http.get(Uri.parse('$baseUrl/$maKH'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return KhachHang.fromJson(jsonResponse);
    } else {
      // If the server did not return a 200 OK response, throw an error.
      print('Failed to load KhachHang');
      return null;
    }
  }
}
