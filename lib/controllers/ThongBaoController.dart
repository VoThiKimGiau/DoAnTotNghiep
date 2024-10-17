import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
import '../models/TBKH.dart';
import '../models/ThongBao.dart';

class ThongBaoController{
  Future<List<TBKH>> fetchTBKH(String makh) async {
    final response = await http.get(
        Uri.parse('http://${IpConfig.ipConfig}/api/tbkh/makh/$makh'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<TBKH> tbkhList = body.map((dynamic item) => TBKH.fromJson(item))
          .toList();
      return tbkhList;
    } else {
      throw Exception('Failed to load TBKH');
    }
  }
  Future<ThongBao> fetchThongBao(String maThongBao) async {
    final response = await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/thongbao/$maThongBao'));

    if (response.statusCode == 200) {
      return ThongBao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load ThongBao');
    }
  }

}