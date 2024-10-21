import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:http/http.dart' as http;
class ChiTietSPController{
  Future<ChiTietSP> layCTSPTheoMa(String maCTSP) async
  {
   final response=await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/chitietsp/detail/mactsp?maCTSP=$maCTSP'));
   if(response.statusCode==200)
     {
       return ChiTietSP.fromJson(json.decode(response.body));
     }
   else
     throw Exception("Lỗi khi lay san pham");
  }
  Future<List<ChiTietSP>> layDanhSachCTSPTheoMaSP(String maSP) async
  {
    final response=await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/chitietsp/detail?maSanPham=$maSP'));
    if(response.statusCode==200)
    {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => ChiTietSP.fromJson(item)).toList();
    }
    else
      throw Exception("Lỗi khi lay san pham");
  }

}