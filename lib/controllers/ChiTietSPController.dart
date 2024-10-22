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
  Future<List<ChiTietSP>> layDanhSachCTSPTheoMaSP(String maSP) async {
    final response = await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/chitietsp/detail?maSanPham=$maSP'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print('Response body: ${response.body}'); // In ra nội dung phản hồi
      return jsonResponse.map((item) => ChiTietSP.fromJson(item)).toList();
    } else {
      print('Error: ${response.statusCode}'); // In ra mã lỗi
      throw Exception("Lỗi khi lấy sản phẩm");
    }
  }
  Future<List<ChiTietSP>> fetchAllChiTietSPByMaNCC(String maNCC) async {
    List<ChiTietSP> allChiTietSPs = [];
    int page = 0;
    int pageSize = 10;
    bool hasNextPage = true;

    while (hasNextPage) {
      final response = await http.get(Uri.parse('http://${IpConfig.ipConfig}/api/chitietsp?page=$page&size=$pageSize&maNCC=$maNCC'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body)['data'];

        // Parse danh sách sản phẩm từ API
        List<dynamic> jsonList = jsonResponse['items'];
        List<ChiTietSP> chiTietSPPage = jsonList.map((json) => ChiTietSP.fromJson(json)).toList();

        // Thêm dữ liệu trang vào danh sách tổng
        allChiTietSPs.addAll(chiTietSPPage);

        // Kiểm tra có trang tiếp theo không
        hasNextPage = jsonResponse['hasNextPage'];
        page++; // Tăng số trang để fetch trang tiếp theo
      } else {
        throw Exception('Failed to load ChiTietSP');
      }
    }

    return allChiTietSPs;
  }

}