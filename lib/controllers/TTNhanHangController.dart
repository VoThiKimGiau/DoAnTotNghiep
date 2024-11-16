import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/TTNhanHang.dart';

class TTNhanHangController {
  final String baseUrl = '${IpConfig.ipConfig}api/ttnhanhang';

  // Lấy thông tin địa chỉ nhận hàng theo mã khách hàng
  Future<List<TTNhanHang>> fetchTTNhanHangByCustomer(String? maKH) async {
    final response =
    await http.get(Uri.parse('$baseUrl/byCustomer?maKH=$maKH'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => TTNhanHang.fromJson(json)).toList();
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response body: ${utf8.decode(response.bodyBytes)}');
      throw Exception(
          'Failed to load TTNhanHang. Status code: ${response.statusCode}');
    }
  }

  // Lấy thông tin địa chỉ nhận hàng theo mã địa chỉ
  Future<TTNhanHang?> fetchTTNhanHang(String maTTNH) async {
    final response = await http.get(Uri.parse('$baseUrl/$maTTNH'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return TTNhanHang.fromJson(data);
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response body: ${utf8.decode(response.bodyBytes)}');
      throw Exception(
          'Failed to load TTNhanHang. Status code: ${response.statusCode}');
    }
  }

  Future<TTNhanHang?> createTTNhanHang(TTNhanHang ttNhanHang) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(ttNhanHang.toJson()),
    );

    if (response.statusCode == 201) {
      // If the server returns an OK response, parse the JSON
      return TTNhanHang.fromJson(json.decode(response.body));
    } else {
      // If the response was not OK, throw an exception
      throw Exception('Failed to create TTNhanHang: ${response.reasonPhrase}');
    }
  }

  Future<List<TTNhanHang>> getAllTTNhanHang() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => TTNhanHang.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load TTNhanHang: ${response.reasonPhrase}');
    }
  }
}
