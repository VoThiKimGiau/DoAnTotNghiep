import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/models/SPYeuThich.dart';
import 'package:http/http.dart' as http;

import '../config/IpConfig.dart';
import '../models/SanPham.dart';

class SPYeuThichController {
  Future<List<SPYeuThich>> fetchSPYeuThichByKH(String? maKH) async {
    String baseUrl =
        'http://${IpConfig.ipConfig}/api/sp-yeu-thich/khach-hang/$maKH';

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => SPYeuThich.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load SPYeuThich data');
    }
  }
}
