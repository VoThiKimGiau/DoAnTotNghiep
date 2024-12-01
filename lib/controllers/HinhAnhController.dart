import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/HinhAnhSP.dart';
import 'package:http/http.dart' as http;
class HinhAnhController {

  Future<String> fetchDuongDan(String maHinhAnh) async {
    final url = '${IpConfig.ipConfig}api/hinhanh/$maHinhAnh';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If the server returns a response with code 200, parse the JSON
        final Map<String, dynamic> jsonData = json.decode(response.body);
        HinhAnhSP hinhAnhSP = HinhAnhSP.fromJson(jsonData);

        // Return the 'duongDan' from the parsed object
        return hinhAnhSP.lienKetURL;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load image data');
      }
    } catch (e) {
      print('Error fetching image: $e');
      return 'Error: $e';
    }
  }

  Future<List<HinhAnhSP>> fetchAllImages() async {
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/hinhanh'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => HinhAnhSP.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<HinhAnhSP> createImage(HinhAnhSP hinhAnhSP) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/hinhanh'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(hinhAnhSP.toJson()),
    );

    if (response.statusCode == 200) {
      return HinhAnhSP.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create image: ${response.statusCode}');
    }
  }

  Future<HinhAnhSP> updateImage(String id, HinhAnhSP hinhAnhSP) async {
    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/hinhanh/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(hinhAnhSP.toJson()),
    );

    if (response.statusCode == 200) {
      return HinhAnhSP.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Hình ảnh không tồn tại');
    } else {
      throw Exception('Cập nhật hình ảnh thất bại: ${response.statusCode}');
    }
  }
}