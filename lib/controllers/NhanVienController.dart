import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/NhanVien.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NhanVienController {
  Future<String?> dangNhapNV(String tk, String mk) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/nhanvien/login?tenTK=$tk&matKhau=$mk'),
    );

    if (response.statusCode == 200) {
      // Giải mã token trực tiếp từ response body
      String token = response.body;

      // Giải mã token để lấy claim "chucVu"
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String chucVu = decodedToken['chucVu'];
      String maNV= decodedToken['ma'];
      // Lưu chucVu vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('chucVu', chucVu);
      await prefs.setString("token", token);
      return maNV;
    } else {
      print(response.statusCode);
      return null;
    }
  }
  Future<String?> getChucVu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lấy giá trị của biến "chucVu" từ SharedPreferences
    String? chucVu = prefs.getString('chucVu');
    return chucVu;
  }
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lấy giá trị của biến "chucVu" từ SharedPreferences
    String? token = prefs.getString('token');
    return token;
  }
}
