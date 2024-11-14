import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhanVienController.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:http/http.dart' as http;
class PhieuNhapController{

  Future<List<PhieuNhap>> layDanhSachPhieuNhap() async
  {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    // Gửi request với Bearer token trong headers
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/phieunhap'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
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
  Future<String> generateOrderCode() async {
    List<PhieuNhap> phieuNhaps = await layDanhSachPhieuNhap();
    int currentCount = phieuNhaps.length;

    // Generate new order code based on the current count
    String newOrderCode = 'PN${currentCount + 1}';
    return newOrderCode;
  }
  Future<PhieuNhap> taoPhieuNhap(PhieuNhap phieuNhap) async {

    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    // Gửi request với Bearer token trong headers
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/phieunhap'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'maPhieuNhap': phieuNhap.maPhieuNhap,
        'nhaCungCap': phieuNhap.nhaCungCap,
        'maNV': phieuNhap.maNV,
        'tongTien': phieuNhap.tongTien,
        'ngayDat': phieuNhap.ngayDat.toIso8601String(), // Chuyển đổi ngày thành chuỗi
        'ngayGiao': phieuNhap.ngayGiao?.toIso8601String(), // Chuyển đổi ngày thành chuỗi
      }),
    );

    if (response.statusCode == 201) {
      return PhieuNhap.fromJson(json.decode(response.body));
    } else {
      throw Exception("Không thể tạo phiếu nhập mới");
    }
  }
  Future<void> updatePhieuNhapDaGiao(String maPN) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final String url = '${IpConfig.ipConfig}api/phieunhap/daGiaoHang/$maPN';

    try {

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Nếu cập nhật thành công
        final data = json.decode(response.body);
        print('Cập nhật trạng thái phiếu nhập thành công: $data');
      } else {
        // Nếu có lỗi
        throw Exception('Không thể cập nhật trạng thái: ${response.statusCode}');
      }
    } catch (error) {
      print('Đã xảy ra lỗi khi cập nhật phiếu nhập: $error');
    }
  }
  Future<List<PhieuNhap>> getPhieuNhapByTrangThai(String trangThai) async {
    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final response = await http.get(Uri.parse('${IpConfig.ipConfig}api/phieunhap/trangthai/$trangThai'),
      headers: {
        'Authorization': 'Bearer $token',
      },);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<PhieuNhap> phieuNhapList = body.map((dynamic item) => PhieuNhap.fromJson(item)).toList();
      return phieuNhapList;
    } else {
      throw Exception('Failed to load PhieuNhap');
    }
  }


  // Phương thức lọc phiếu nhập giữa hai ngày
  Future<List<PhieuNhap>> filterPhieuNhapBetweenDates(String startDate, String endDate) async {
    final url = Uri.parse('${IpConfig.ipConfig}api/phieunhap/between-dates?startDate=$startDate&endDate=$endDate');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => PhieuNhap.fromJson(item)).toList();
    } else {
      throw Exception('Không thể lấy danh sách phiếu nhập giữa hai ngày');
    }
  }
} 