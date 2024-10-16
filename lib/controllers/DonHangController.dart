import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/DonHang.dart';

class DonHangController {
  Future<List<DonHang>> fetchDonHang(String maKH) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/donhang/byCustomer?maKH=$maKH'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((donHang) => DonHang.fromJson(donHang)).toList();
    } else {
      throw Exception('Failed to load DonHang');
    }
  }
}
