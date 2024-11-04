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
}