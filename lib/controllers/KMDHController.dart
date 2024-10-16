
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/IpConfig.dart';
import '../models/KMDH.dart';

class KMDHController {
  final String baseUrl = 'http://${IpConfig.ipConfig}/api/kmdh/madh';

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
}

