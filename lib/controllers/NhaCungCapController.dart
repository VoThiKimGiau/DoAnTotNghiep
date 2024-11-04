import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:http/http.dart' as http;

class NCCController{
  Future<List<NhaCungCap>> fetchSuppliers() async {
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/nhacungcap'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      // Chuyển từ danh sách JSON thành danh sách đối tượng Supplier
      return jsonList.map((jsonItem) => NhaCungCap.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load suppliers');
    }
  }

  Future<NhaCungCap?> fetchSupById(String maNCC)async{
    final response =await http.get(Uri.parse('${IpConfig.ipConfig}api/nhacungcap/${maNCC}'));
    if(response.statusCode==200)
      {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = json.decode(decodedBody);
        return NhaCungCap.fromJson(jsonResponse);
      }
    else
      print("error get sup by id");
  }
}