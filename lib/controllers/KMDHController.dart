
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/KMDH.dart';

class KMDHController {
  final String baseUrl = '${IpConfig.ipConfig}api/kmdh/madh';

  Future<List<KMDH>> fetchKMDH(String madh) async {
    final response = await http.get(Uri.parse('$baseUrl?madh=$madh'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      // Map each item in the list to a KMDH object and return the list
      return jsonResponse.map((item) => KMDH.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load KMDH data');
    }
  }

  Future<KMDH?> createKMDH(KMDH kmdh) async {
    const String apiUrl = '${IpConfig.ipConfig}api/kmdh';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(kmdh.toJson()),
      );

      if (response.statusCode == 201) {
        return KMDH.fromJson(jsonDecode(response.body));
      } else {
        print('Lỗi: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      return null;
    }
  }
}

