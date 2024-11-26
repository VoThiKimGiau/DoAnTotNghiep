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
  Future<http.Response> registerEmployee(NhanVien registerEmployeeRequest) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final url = Uri.parse('${IpConfig.ipConfig}api/nhanvien/register');
    try {
      final response = await http.post(
        url, headers: <String, String>{
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'},
        body: jsonEncode(registerEmployeeRequest.toJson()),
      );
      return response;
    } catch (e) {
      throw Exception("Error registering employee: $e");
    }
  }
  // Get all employees
  Future<List<dynamic>> getAllEmployees() async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final url = Uri.parse('${IpConfig.ipConfig}api/nhanvien/all');
    try {
      final response = await http.get(url, headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Error fetching employees");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Get employee by ID
  Future<Map<String, dynamic>> getEmployeeById(String maNV) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final url = Uri.parse('${IpConfig.ipConfig}api/nhanvien/$maNV');
    try {
      final response = await http.get(url, headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Employee not found");
      }
    } catch (e) {
      throw Exception("Error fetching employee: $e");
    }
  }

  // Update employee

  Future<http.Response> updateEmployee(String maNV, NhanVien nhanVienDetails) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final url = Uri.parse('${IpConfig.ipConfig}api/nhanvien/$maNV');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(nhanVienDetails.toJson()), // Chuyển đổi thành JSON string
      );
      return response;
    } catch (e) {
      throw Exception("Error updating employee: $e");
    }
  }

}
