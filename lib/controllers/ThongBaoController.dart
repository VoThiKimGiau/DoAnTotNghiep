import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
import '../models/TBKH.dart';
import '../models/ThongBao.dart';
import 'NhanVienController.dart';

class ThongBaoController {
  Future<List<TBKH>> fetchTBKH(String? makh) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/tbkh/makh/$makh'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<TBKH> tbkhList = body.map((dynamic item) => TBKH.fromJson(item)).toList();
      return tbkhList;
    } else {
      throw Exception('Failed to load TBKH: ${response.reasonPhrase}');
    }
  }

  Future<List<ThongBao>> fetchAllThongBao() async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/thongbao'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse.map<ThongBao>((item) => ThongBao.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ThongBao: ${response.reasonPhrase}');
    }
  }

  Future<ThongBao> fetchThongBao(String maThongBao) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/thongbao/$maThongBao'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ThongBao.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load ThongBao: ${response.reasonPhrase}');
    }
  }

  Future<ThongBao> createThongBao(ThongBao thongBaoData) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/thongbao'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(thongBaoData),
    );

    if (response.statusCode == 201) {
      return ThongBao.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to create notification: ${response.reasonPhrase}');
    }
  }

  Future<ThongBao> updateThongBao(String maTB, ThongBao updatedThongBaoData) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/thongbao/${maTB.trim()}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updatedThongBaoData),
    );

    if (response.statusCode == 200) {
      return ThongBao.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update notification: ${response.reasonPhrase}');
    }
  }

  Future<bool> xoaTB(String maTB) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.delete(
      Uri.parse('${IpConfig.ipConfig}api/thongbao/${maTB.trim()}'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Không thể xóa thông báo: ${response.reasonPhrase}");
    }
  }

  Future<int> getUnreadNotificationCount(String? maKhachHang) async {
    try {
      List<TBKH> tbkhList = await fetchTBKH(maKhachHang);
      return tbkhList.where((tbkh) => !tbkh.daXem).length;
    } catch (e) {
      print('Error getting unread notification count: $e');
      return 0;
    }
  }
}