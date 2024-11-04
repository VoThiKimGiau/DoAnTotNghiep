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
}
