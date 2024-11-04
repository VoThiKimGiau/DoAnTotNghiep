// lib/controllers/GiaoHangController.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/GiaoHang.dart';

class GiaoHangController {
  final String baseUrl = '${IpConfig.ipConfig}api/giaohang';

  Future<GiaoHang?> fetchGiaoHang(String donHang) async {
    final response = await http.get(Uri.parse('$baseUrl/donHang?donHang=$donHang'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return GiaoHang.fromJson(data);
    } else {
      throw Exception('Failed to load GiaoHang');
    }
  }

  Future<String?> getCoordinatesFromAddress(String address) async {
    final url = 'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json';

    // Thêm User-Agent vào headers
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "datn_cntt304_bandogiadung/1.0 (vothikimgiau16122003@gmail.com)"
      },
    );

    print('Nominatim Response status: ${response.statusCode}');
    print('Nominatim Response body: ${response.body}'); // In ra nội dung phản hồi

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return '${data[0]['lat']},${data[0]['lon']}'; // Trả về tọa độ
      } else {
        print('Không tìm thấy tọa độ cho địa chỉ: $address');
      }
    } else {
      print('Lỗi khi gọi Nominatim: ${response.statusCode}');
    }
    return null;
  }

  Future<double?> getDistanceOSRM(String origin, String destination) async {
    final url = 'https://router.project-osrm.org/route/v1/driving/$origin;$destination?overview=false';

    final response = await http.get(Uri.parse(url));

    print('OSRM Response status: ${response.statusCode}');
    print('OSRM Response body: ${response.body}'); // In ra nội dung phản hồi

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        return data['routes'][0]['distance'] / 1000; // Trả về khoảng cách tính bằng km
      } else {
        print('Không tìm thấy lộ trình.');
      }
    } else {
      print('Lỗi khi gọi OSRM: ${response.statusCode}');
    }
    return null;
  }
}
