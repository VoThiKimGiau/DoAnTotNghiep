import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:http/http.dart' as http;

class NCCController{
  Future<List<NhaCungCap>> fetchSuppliers() async {
    final response = await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/nhacungcap'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      // Chuyển từ danh sách JSON thành danh sách đối tượng Supplier
      return jsonList.map((jsonItem) => NhaCungCap.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load suppliers');
    }
  }
}