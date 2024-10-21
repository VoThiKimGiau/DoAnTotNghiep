import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:http/http.dart' as http;

class DanhMucSPController{
  final String baseUrl = 'http://${IpConfig.ipConfig}/api/danhmucsp';

  Future<List<DanhMucSP>> fetchDanhMucSP() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => DanhMucSP.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load DanhMucSP data');
    }
  }
}