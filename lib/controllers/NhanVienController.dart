import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/NhanVien.dart';
import 'package:http/http.dart' as http;
class NhanVienController{
  Future<NhanVien?> dangNhapNV(String tk,String mk) async
  {
    final response=await http.post(Uri.parse('http://${IpConfig.ipConfig}/api/nhanvien/login?tenTK=$tk&matKhau=$mk'));
    if(response.statusCode==200)
      {
        final Map<String,dynamic> jsonResponse=json.decode(response.body);
        return NhanVien.fromJson(jsonResponse);
      }
    else
      {
        print(response.statusCode);
        return null;
      }
  }

}