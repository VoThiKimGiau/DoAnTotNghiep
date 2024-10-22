import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:http/http.dart' as http;
class PhieuNhapController{
  Future<List<PhieuNhap>> layDanhSachPhieuNhap() async
  {
    final response= await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/phieunhap'));
    if(response.statusCode==200)
      {
        List<dynamic> jsonResponse=json.decode(response.body);
        return jsonResponse.map<PhieuNhap>((item) => PhieuNhap.fromJson(item)).toList();
      }
    else
      {
        throw Exception("Không thể tải danh sách phiếu nhập");
      }
  }
  Future<PhieuNhap> taoPhieuNhap(PhieuNhap phieuNhap) async {
    final response = await http.post(
      Uri.parse('http://${IpConfig.ipConfig}/api/phieunhap'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'maPhieuNhap': phieuNhap.maPhieuNhap,
        'nhaCungCap': phieuNhap.nhaCungCap,
        'maNV': phieuNhap.maNV,
        'tongTien': phieuNhap.tongTien,
        'ngayDat': phieuNhap.ngayDat.toIso8601String(), // Chuyển đổi ngày thành chuỗi
        'ngayGiao': phieuNhap.ngayGiao.toIso8601String(), // Chuyển đổi ngày thành chuỗi
      }),
    );

    if (response.statusCode == 201) { // 201 Created
      return PhieuNhap.fromJson(json.decode(response.body));
    } else {
      throw Exception("Không thể tạo phiếu nhập mới");
    }
  }
} 