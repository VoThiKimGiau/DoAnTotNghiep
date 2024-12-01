import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:http/http.dart' as http;

class NCCController{
  Future<List<NhaCungCap>> fetchSuppliers() async {
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/nhacungcap'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
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

  Future<NhaCungCap> createNhaCungCap(NhaCungCap nhaCungCap) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/nhacungcap'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(nhaCungCap.toJson()),
    );

    if (response.statusCode == 201) {
      return NhaCungCap.fromJson(json.decode(response.body));
    } else {
      throw Exception('Tạo mới nhà cung cấp thất bại: ${response.statusCode}');
    }
  }

  Future<NhaCungCap> updateNhaCungCap(String maNCC, NhaCungCap nhaCungCapDetails) async {
    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/nhacungcap/$maNCC'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(nhaCungCapDetails.toJson()),
    );

    if (response.statusCode == 200) {
      return NhaCungCap.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Không tìm thấy nhà cung cấp với mã: $maNCC');
    } else {
      throw Exception('Cập nhật nhà cung cấp thất bại: ${response.statusCode}');
    }
  }
}