// lib/controllers/GiaoHangController.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/GiaoHang.dart';

class GiaoHangController {
  final String baseUrl = '${IpConfig.ipConfig}api/giaohang';

  Future<GiaoHang?> fetchGiaoHang(String donHang) async {
    final response =
        await http.get(Uri.parse('$baseUrl/donHang?donHang=$donHang'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return GiaoHang.fromJson(data);
    } else {
      throw Exception('Failed to load GiaoHang');
    }
  }

  // Here.com
  // Mail: cuahanggiadunghuit@gmail.com
  // Pass: Cntt304cuahanggiadunghuit@
  // App ID: KnDuhWETcgnVcmXRXS2G
  // API Key: 8AOpT7e0QxfGS0TLD08A4M66K80ioaXiwMU1zUUv9IY

  Future<Map<String, double>> getCoordinates(
      String address, String apiKey) async {
    final String url =
        'https://geocode.search.hereapi.com/v1/geocode?q=$address&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final latitude = data['items'][0]['position']['lat'] as double;
      final longitude = data['items'][0]['position']['lng'] as double;
      return {'latitude': latitude, 'longitude': longitude};
    } else {
      throw Exception('Failed to load coordinates');
    }
  }

  Future<double> getDistance(
      String address1, String address2, String apiKey) async {
    final String url =
        'https://router.hereapi.com/v8/routes?origin=$address1&destination=$address2&return=summary&transportMode=car&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final distance = data['routes'][0]['sections'][0]['summary']['length']
          as int; // distance in meters
      return distance / 1000.0; // convert to kilometers
    } else {
      throw Exception('Failed to load distance');
    }
  }
}
