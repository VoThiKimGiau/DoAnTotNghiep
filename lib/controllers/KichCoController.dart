import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
class KichCoController
{
  Future<String> layTenKichCo(String maKichCo) async
  {
    final response = await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/kich-cos/$maKichCo'));
    if(response.statusCode==200)
      {
        final Map<String,dynamic> jsonRequeue=json.decode(response.body);
        return jsonRequeue['tenKichCo'];
      }
    else
      throw Exception("Lỗi lay ten kích cỡ ");
  }
}