import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/KichCo.dart';
import 'package:http/http.dart' as http;
class KichCoController
{
  Future<String> layTenKichCo(String maKichCo) async
  {
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/kich-cos/$maKichCo'));
    if(response.statusCode==200)
      {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonRequeue = json.decode(responseBody);
        return jsonRequeue['tenKichCo'];
      }
    else
      throw Exception("Lỗi lấy tên kích cỡ ");
  }

  Future<KichCo> layKichCo(String maKichCo) async
  {
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/kich-cos/$maKichCo'));
    if(response.statusCode==200)
    {
      final Map<String, dynamic> jsonResponse =
      json.decode(utf8.decode(response.bodyBytes));

      return KichCo.fromJson(jsonResponse);
    }
    else
      throw Exception("Lỗi lấy tên kích cỡ ");
  }
}