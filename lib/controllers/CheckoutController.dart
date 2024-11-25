import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:datn_cntt304_bandogiadung/models/KMKH.dart';
import 'package:datn_cntt304_bandogiadung/models/Promotion.dart';
import 'package:http/http.dart' as http;

import '../models/ChiTietDonHang.dart';

class CheckoutController {
  Future<List<KMKH>> fetchKMKH(String makh) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/kmkh/khachhang/$makh'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => KMKH.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load KMKH');
    }
  }

  Future<Promotion> fetchDetailKM(String makm) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/khuyenmai/$makm'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = utf8.decode(response.bodyBytes);
      dynamic jsonResponse = json.decode(decodedJson);
      return Promotion.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load KM theo mã');
    }
  }



  Future<String> checkOut(String ttnh, String? kh, String htgh, String pttt,
      double tt, bool ttoan) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/donhang/add'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      },
      body: json.encode({
        "daThanhToan": ttoan,
        "maTTNH": ttnh,
        "maKH": kh,
        "hinhThucGiaoHang": htgh,
        "phuongThucThanhToan": pttt,
        "thanhTien": tt,
      }),
    );

    print(json.encode({
      "daThanhToan": ttoan,
      "maTTNH": ttnh,
      "maKH": kh,
      "hinhThucGiaoHang": htgh,
      "phuongThucThanhToan": pttt,
      "thanhTien": tt,
    }));

    if (response.statusCode == 200) {
      final decodedJson = utf8.decode(response.bodyBytes);
      dynamic jsonResponse = json.decode(decodedJson);
      print(jsonResponse["maDH"]);
      return jsonResponse["maDH"];
    } else if (response.statusCode == 400) {
      throw Exception('Yêu cầu không hợp lệ: ${response.body}');
    } else {
      throw Exception('Lỗi: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> addChiTietDonHang(ChiTietDonHang chiTietDonHang) async {
    final String apiUrl =
        '${IpConfig.ipConfig}api/chitietdonhang?maDonHang=${chiTietDonHang.donHang}&maCTSP=${chiTietDonHang.sanPham}&sl=${chiTietDonHang.soLuong}';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final ChiTietDonHang savedChiTiet =
          ChiTietDonHang.fromJson(json.decode(response.body));
      print('Chi tiết đơn hàng đã được thêm: $savedChiTiet');
    } else if (response.statusCode == 400) {
      print('Yêu cầu không hợp lệ: ${response.body}');
    } else {
      print('Lỗi: ${response.statusCode} - ${response.body}');
    }
  }
}
