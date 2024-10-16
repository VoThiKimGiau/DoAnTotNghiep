import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/DonHang.dart';

class ChiTietDonHangController {
  Future<int> fetchProductCount(String madh) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/chitietdonhang/count?madh=$madh'),
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load product count');
    }
  }
}
