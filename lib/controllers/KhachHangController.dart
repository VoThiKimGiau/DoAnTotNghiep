import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';

class KhachHangController {
  final String baseUrl = 'http://${IpConfig.ipConfig}/api/khachhang';

  Future<KhachHang?> getKhachHang(String? maKH) async {
    final response = await http.get(Uri.parse('$baseUrl/$maKH'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return KhachHang.fromJson(jsonResponse);
    } else {
      print('Failed to load KhachHang');
      return null;
    }
  }

  Future<KhachHang?> login(String tenTK, String matKhau) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login?tenTK=$tenTK&matKhau=$matKhau'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return KhachHang.fromJson(jsonResponse);
    } else {
      print('Login failed');
      return null;
    }
  }

  Future<List<KhachHang>> fetchAllCustomer() async {
    String baseUrl = 'http://${IpConfig.ipConfig}/api/khachhang';

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => KhachHang.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load KhachHang data');
    }
  }

  Future<KhachHang> insertCustomer(KhachHang kh) async {
    final response = await http.post(
      Uri.parse('http://${IpConfig.ipConfig}/api/khachhang'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode(kh.toJson()),
    );

    if (response.statusCode == 200) {
      return KhachHang.fromJson(json.decode(response.body));
    } else {
      throw Exception("Không thể tạo khách hàng mới");
    }
  }
}
