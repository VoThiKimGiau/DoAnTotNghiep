import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/KMKH.dart';
import 'package:datn_cntt304_bandogiadung/models/Promotion.dart';
import 'package:http/http.dart' as http;

class CheckoutController {
  Future<List<KMKH>> fetchKMKH(String makh) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/kmkh/khachhang/$makh'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => KMKH.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load product count');
    }
  }

  Future<Promotion> fetchDetailKM(String makm) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/khuyenmai/$makm'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return Promotion.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load product count');
    }
  }
}
