import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
import '../models/ChiTietGioHang.dart';

class ChiTietGioHangController {
  // Lấy số lượng sản phẩm trong giỏ hàng
  Future<int> fetchProductCount(String maGioHang) async {
    final response = await http.get(
      Uri.parse(
          'http://${IpConfig.ipConfig}/api/chitietgiohang/count?maGioHang=$maGioHang'),
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load product count');
    }
  }

  // Lấy danh sách sản phẩm trong giỏ hàng
  Future<List<ChiTietGioHang>> fetchListProduct(String maGioHang) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/chitietgiohang?maGioHang=$maGioHang'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => ChiTietGioHang.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  // Thêm chi tiết giỏ hàng
  Future<ChiTietGioHang> themChiTietGioHang(
      ChiTietGioHang chiTietGioHang) async {
    print("Dữ liệu gửi đi: ${json.encode(chiTietGioHang.toJson())}");
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/chitietgiohang'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode(chiTietGioHang.toJson()),
    );

    if (response.statusCode == 200) {
      return ChiTietGioHang.fromJson(json.decode(response.body));
    } else {
      print("Phản hồi lỗi: ${response.body}");
      throw Exception("Không thể thêm chi tiết giỏ hàng: ${response.body}");
    }
  }

  // Lấy mã giỏ hàng dựa trên mã khách hàng
  Future<String> fetchMaGioHang(String maKH) async {
    final response = await http.get(
      Uri.parse(
          '${IpConfig.ipConfig}/api/giohang?khachHang/$maKH'), // Đường dẫn API
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['maGioHang']; // Giả sử API trả về maGioHang
    } else {
      throw Exception('Không thể lấy mã giỏ hàng');
    }
  }

  // Update cart
  Future<ChiTietGioHang> capnhatChiTietGioHang(
      ChiTietGioHang chiTietGioHang) async {
    print("Dữ liệu gửi đi: ${json.encode(chiTietGioHang.toJsonForUpdate())}");
    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/chitietgiohang/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(chiTietGioHang.toJsonForUpdate()),
    );

    if (response.statusCode == 200) {
      return ChiTietGioHang.fromJson(json.decode(response.body));
    } else {
      print("Phản hồi lỗi: ${response.body}");
      throw Exception("Không thể cap nhat chi tiết giỏ hàng: ${response.body}");
    }
  }

  //Delete item cart
  Future<bool> xoaChiTietGioHang(String maGioHang, String maCTSP) async {
    final response = await http.delete(
      Uri.parse(
          '${IpConfig.ipConfig}api/chitietgiohang/delete/$maGioHang/$maCTSP'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Không thể cap nhat chi tiết giỏ hàng: ${response.body}");
    }
  }

  // Delete cart
  Future<bool> xoaTatCaGioHang(String maGioHang) async {
    final response = await http.delete(
      Uri.parse('${IpConfig.ipConfig}api/chitietgiohang/delete-all/$maGioHang'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Không thể cap nhat chi tiết giỏ hàng: ${response.body}");
    }
  }
}
