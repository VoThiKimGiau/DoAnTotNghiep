import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';

class KhachHangController {
  final String baseUrl = '${IpConfig.ipConfig}api/khachhang';

  Future<KhachHang?> getKhachHang(String? maKH) async {
    final response = await http.get(Uri.parse('$baseUrl/$maKH'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      final Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      return KhachHang.fromJson(jsonResponse);
    } else {
      print('Failed to load KhachHang');
      return null;
    }
  }

  Future<KhachHang?> login(String tenTK, String matKhau) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login?tenTK=$tenTK&matKhau=$matKhau'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return KhachHang.fromJson(jsonResponse);
    } else {
      print('Login failed');
      return null;
    }
  }

  Future<List<KhachHang>> fetchAllCustomer() async {
    String baseUrl = '${IpConfig.ipConfig}api/khachhang';

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => KhachHang.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load KhachHang data');
    }
  }

  Future<KhachHang> insertCustomer(KhachHang kh) async {
    final response = await http.post(
      Uri.parse('${IpConfig.ipConfig}api/khachhang'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode(kh.toJson()),
    );

    if (response.statusCode == 200) {
      return KhachHang.fromJson(json.decode(response.body));
    } else {
      throw Exception("Không thể tạo khách hàng mới");
    }
  }

  Future<void> sendEmail({
    required String apiKeyPublic,
    required String apiKeyPrivate,
    required String fromEmail,
    required String fromName,
    required String toEmail,
    required String toName,
    required int templateID,
    required Map<String, String> variables,
    required String subject,
  }) async
  {
    final url = 'https://api.mailjet.com/v3.1/send';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$apiKeyPublic:$apiKeyPrivate'))}',
      },
      body: json.encode({
        "Messages": [
          {
            "From": {
              "Email": fromEmail,
              "Name": fromName,
            },
            "To": [
              {
                "Email": toEmail,
                "Name": toName,
              }
            ],
            "TemplateID": templateID,
            "TemplateLanguage": true,
            "Subject": subject,
            "Variables": variables,
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      print('Email đã được gửi thành công!');
    } else {
      print('Đã xảy ra lỗi: ${response.body}');
    }
  }

  Future<bool> updateCustomer(String? maKH, KhachHang kh) async {
    final response = await http.put(
      Uri.parse('${IpConfig.ipConfig}api/khachhang/$maKH'),
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode(kh.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw Exception("Khách hàng không được tìm thấy");
    } else {
      throw Exception("Không thể cập nhật thông tin khách hàng");
    }
  }

  Future<KhachHang?> getCustomerByEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/email/$email'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return KhachHang.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      print('Khách hàng không được tìm thấy');
      return null;
    } else {
      print('Lỗi khi tải KhachHang: ${response.statusCode}');
      return null;
    }
  }
}
