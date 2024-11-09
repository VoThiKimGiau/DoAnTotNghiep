import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/KMKH.dart';
import 'package:datn_cntt304_bandogiadung/models/Promotion.dart';
import 'package:http/http.dart' as http;

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
      throw Exception('Failed to load product count');
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
      throw Exception('Failed to load product count');
    }
  }

  Future<String> checkOut(
      String maTTNH, maKH, hTTT, pTTT, double thanhTien, bool datt) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/donhang/add'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
      },
      body: json.encode({
        "daThanhToan": datt,
        "maTTNH": maTTNH,
        "maKH": maKH,
        "hinhThucGiaoHang": hTTT,
        "phuongThucThanhToan": pTTT,
        "thanhTien": thanhTien,
      }),
    );

    print(json.encode({
      "daThanhToan": datt,
      "maTTNH": maTTNH,
      "maKH": maKH,
      "hinhThucGiaoHang": hTTT,
      "phuongThucThanhToan": pTTT,
      "thanhTien": thanhTien,
    }));

    if (response.statusCode == 200) {
      final decodedJson = utf8.decode(response.bodyBytes);
      dynamic jsonResponse = json.decode(decodedJson);
      print(jsonResponse["maDH"]);
      return jsonResponse["maDH"];
    } else {
      throw Exception('Failed to load product count');
    }
  }
}
