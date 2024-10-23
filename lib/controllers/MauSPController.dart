import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/MauSP.dart';
import 'package:http/http.dart' as http;
class MauSPController{
  
  Future<String> layTenMauByMaMau(String maMau) async {
    final response =await http.get(Uri.parse(('http://${IpConfig.ipConfig}/api/mau-sps/$maMau')));
    if (response.statusCode==200)
      {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['tenMau']; // Adjust the key according to your actual response
      }
    else
      {
        throw Exception('Failed to load color name');
      }
  }

  Future<int> fetchProductCount(String madh) async {
    final response = await http.get(
      Uri.parse('http://${IpConfig.ipConfig}/api/chitietdonhang/count?madh=$madh'),
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load product count');
    }
  }

  Future<MauSP> layMauTheoMa(String maMau) async {
    final response = await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/mau-sps/$maMau'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
      json.decode(utf8.decode(response.bodyBytes));

      return MauSP.fromJson(jsonResponse);
    } else {
      print('Error: ${response.statusCode}'); // In ra mã lỗi
      throw Exception("Lỗi khi lấy màu sản phẩm");
    }
  }
}