import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:http/http.dart' as http;
class ChiTietSPController{
  final baseUrl="http://${IpConfig.ipConfig}";
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
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      //print('Response body: ${response.body}'); // In ra nội dung phản hồi
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
  Future<int> getTotalSlKho() async {
    final response = await http.get(Uri.parse('$baseUrl/api/chitietsp/tong-slkho'));
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total stock quantity');
    }
  }

  // Get total inventory value
  Future<double> getTotalInventoryValue() async {
    final response = await http.get(Uri.parse('$baseUrl/api/chitietsp/tong-gia-tri-ton'));
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load total inventory value');
    }
  }

  // Get total sold inventory value
  Future<double> getTotalSoldValue() async {
    final response = await http.get(Uri.parse('$baseUrl/api/chitietsp/tong-gia-tri-da-ban'));
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load total sold inventory value');
    }
  }

  // Get total number of products below stock threshold
  Future<int> getItemsWithLowInventory(int threshold) async {
    final response = await http.get(Uri.parse('$baseUrl/api/chitietsp/duoi-nguong-ton-kho?threshold=$threshold'));
    if (response.statusCode == 200) {
      List<dynamic> items = jsonDecode(response.body);
      return items.length;
    } else {
      throw Exception('Failed to load items with low inventory');
    }
  }

  // Get total number of products available for sale
  Future<int> getAvailableItems() async {
    final response = await http.get(Uri.parse('$baseUrl/api/chitietsp/con-ton-kho'));
    if (response.statusCode == 200) {
      List<dynamic> items = jsonDecode(response.body);
      return items.length;
    } else {
      throw Exception('Failed to load available items');
    }
  }
  Future<List<dynamic>> fetchChiTietSPByCategory(String maDanhMuc) async {
    final url = Uri.parse("$baseUrl/api/chitietsp/by-category?maDanhMuc=$maDanhMuc");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data;
      } else {
        throw Exception("Failed to load product details by category");
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  // Hàm fetch sản phẩm theo tên sản phẩm (search)
  Future<List<dynamic>> fetchChiTietSPByTenSanPham(String tenSP) async {
    final url = Uri.parse("$baseUrl/api/chitietsp/search?tenSP=$tenSP");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data;
      } else {
        throw Exception("Failed to load product details by name");
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
  Future<List<ChiTietSP>> fetchChiTietSP(String maDM, String maNCC) async {
    final url = Uri.parse('$baseUrl/api/chitietsp/madm/$maDM/mancc/$maNCC');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Decode the JSON response into a List of ChiTietSP objects
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ChiTietSP.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ChiTietSP');
    }
  }
  Future<List<ChiTietSP>> fetchLowQuantity() async {
    final url = Uri.parse('$baseUrl/api/chitietsp/low-stock');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Decode the JSON response into a List of ChiTietSP objects
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ChiTietSP.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ChiTietSP');
    }
  }
}