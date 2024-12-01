import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:http/http.dart' as http;

import 'NhanVienController.dart';

class ChiTietSPController {
  final baseUrl = "${IpConfig.ipConfig}";

  Future<int> fetchSLCTSP() async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/chitietsp'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data']['totalCount']; // Trả về giá trị totalCount
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ChiTietSP> addChiTietSP(ChiTietSP chiTietSP) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.post(
      Uri.parse('${baseUrl}api/chitietsp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(chiTietSP.toJson()),
    );

    if (response.statusCode == 200) {
      return ChiTietSP.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Yêu cầu không hợp lệ: ${response.body}');
    } else {
      throw Exception('Thêm chi tiết sản phẩm thất bại: ${response.statusCode}');
    }
  }

  Future<ChiTietSP> updateChiTietSP(ChiTietSP chiTietSP) async {
    final response = await http.put(
      Uri.parse('${baseUrl}api/chitietsp'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(chiTietSP.toJson()),
    );

    if (response.statusCode == 200) {
      return ChiTietSP.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update ChiTietSP: ${response.statusCode}');
    }
  }

  Future<ChiTietSP> layCTSPTheoMa(String maCTSP) async {
    final response = await http.get(Uri.parse(
        '${IpConfig.ipConfig}api/chitietsp/detail/mactsp?maCTSP=$maCTSP'));
    if (response.statusCode == 200) {
      return ChiTietSP.fromJson(json.decode(response.body));
    } else
      throw Exception("Lỗi khi lay san pham");
  }

  Future<List<ChiTietSP>> layDanhSachCTSPTheoMaSP(String maSP) async {
    final response = await http.get(
        Uri.parse('${IpConfig.ipConfig}api/chitietsp/detail?maSanPham=$maSP'));

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
      final response = await http.get(Uri.parse(
          '${IpConfig.ipConfig}api/chitietsp?page=$page&size=$pageSize&maNCC=$maNCC'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body)['data'];

        // Parse danh sách sản phẩm từ API
        List<dynamic> jsonList = jsonResponse['items'];
        List<ChiTietSP> chiTietSPPage =
            jsonList.map((json) => ChiTietSP.fromJson(json)).toList();

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
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }
    final response = await http.get(
        Uri.parse('${baseUrl}api/chitietsp/tong-slkho'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total stock quantity');
    }
  }

  // Get total inventory value
  Future<double> getTotalInventoryValue() async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.get(
        Uri.parse('${baseUrl}api/chitietsp/tong-gia-tri-ton'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load total inventory value');
    }
  }

  // Get total sold inventory value
  Future<double> getTotalSoldValue() async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.get(
        Uri.parse('${baseUrl}api/chitietsp/tong-gia-tri-da-ban'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load total sold inventory value');
    }
  }

  // Get total number of products below stock threshold
  Future<int> getItemsWithLowInventory(int threshold) async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.get(
        Uri.parse(
            '${baseUrl}api/chitietsp/duoi-nguong-ton-kho?threshold=$threshold'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List<dynamic> items = jsonDecode(response.body);
      return items.length;
    } else {
      throw Exception('Failed to load items with low inventory');
    }
  }

  // Get total number of products available for sale
  Future<int> getAvailableItems() async {
    NhanVienController nhanVienController = NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }

    final response = await http.get(
        Uri.parse('${baseUrl}api/chitietsp/con-ton-kho'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List<dynamic> items = jsonDecode(response.body);
      return items.length;
    } else {
      throw Exception('Failed to load available items');
    }
  }

  Future<List<dynamic>> fetchChiTietSPByCategory(String maDanhMuc) async {
    final url =
        Uri.parse("${baseUrl}api/chitietsp/by-category?maDanhMuc=$maDanhMuc");

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

  Future<List<ChiTietSP>> searchProducts({
    String? tenSP,
    String? maDanhMuc,
    String? maNCC,
    int page = 0,
    int size = 10,
  }) async {
    final queryParameters = {
      'page': page.toString(),
      'size': size.toString(),
    };
    if (maDanhMuc != null) {
      queryParameters['maDanhMuc'] = maDanhMuc;
    }
    if (tenSP != null && tenSP.isNotEmpty) {
      queryParameters['tenSP'] = tenSP;
    }

    if (maNCC != null) {
      queryParameters['maNCC'] = maNCC;
    }
    // Send the GET request
    final uri = Uri.parse('${IpConfig.ipConfig}api/chitietsp/search')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> content = data['content'];
      return content.map((item) => ChiTietSP.fromJson(item)).toList();
    } else {
      // Handle the error
      throw Exception('Failed to load products');
    }
  }

  // Hàm fetch sản phẩm theo tên sản phẩm (search)
  Future<List<dynamic>> fetchChiTietSPByTenSanPham(String tenSP) async {
    final url = Uri.parse("${baseUrl}api/chitietsp/search?tenSP=$tenSP");

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
    final url = Uri.parse('${baseUrl}api/chitietsp/madm/$maDM/mancc/$maNCC');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Decode the JSON response into a List of ChiTietSP objects
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ChiTietSP.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ChiTietSP');
    }
  }

  Future<List<ChiTietSP>> fetchChiTietSPByNCCDanhMuc({
    String? maDanhMuc,
    String? maNCC,
    int page = 0,
    int size = 10,
  }) async {
    final queryParameters = <String, String>{
      'page': page.toString(),
      'size': size.toString(),
    };

    // Add 'maDanhMuc' to queryParameters if it's not null
    if (maDanhMuc != null) {
      queryParameters['maDanhMuc'] = maDanhMuc;
    }

    // Add 'maNCC' to queryParameters if it's not null
    if (maNCC != null) {
      queryParameters['maNCC'] = maNCC;
    }

    final uri = Uri.parse('${IpConfig.ipConfig}api/chitietsp/filter')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> content = data['content'];
      return content.map((item) => ChiTietSP.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ChiTietSP');
    }
  }

  Future<List<ChiTietSP>> fetchLowQuantity({
    int page = 0,
    int size = 5,
    int threshold = 10,
  }) async {
    final url = Uri.parse(
        '${baseUrl}api/chitietsp/low-stock?page=$page&size=$size&threshold=$threshold');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> data = responseData['data'];

        return (data['items'] as List)
            .map((item) => ChiTietSP.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load low stock products');
      }
    } catch (e) {
      throw Exception('Error fetching low stock products: $e');
    }
  }

  Future<List<ChiTietSP>> locChiTietSPTheoDanhMuc(
      List<ChiTietSP> danhSachChiTietSP, String maDanhMuc) async {
    try {
      // Gọi API để lấy danh sách chi tiết sản phẩm theo danh mục
      final response = await http.get(Uri.parse(
          '${baseUrl}api/chitietsp/by-category?maDanhMuc=$maDanhMuc'));

      if (response.statusCode == 200) {
        // Parse response thành List các mã sản phẩm thuộc danh mục
        List<dynamic> dsSPThuocDanhMuc = json.decode(response.body);
        Set<String> maSPThuocDanhMuc = dsSPThuocDanhMuc
            .map<String>((item) => item['maSanPham'].toString())
            .toSet();

        // Lọc danh sách chi tiết SP dựa trên các maSP thuộc danh mục
        return danhSachChiTietSP
            .where((ctsp) => maSPThuocDanhMuc.contains(ctsp.maSP))
            .toList();
      } else {
        throw Exception('Không thể lấy danh sách sản phẩm theo danh mục');
      }
    } catch (e) {
      print('Lỗi khi lọc sản phẩm theo danh mục: $e');
      return [];
    }
  }

  // Thêm vào ChiTietSPController
  Future<List<ChiTietSP>> filterLowQuantityProducts(List<ChiTietSP> products,
      {String? maDanhMuc, String? maNCC}) async {
    List<ChiTietSP> results = products;

    if (maDanhMuc != null) {
      // Lấy danh sách mã sản phẩm thuộc danh mục
      List<dynamic> categoryProducts =
          await fetchChiTietSPByCategory(maDanhMuc);
      Set<String> categoryProductIds =
          categoryProducts.map((item) => item['maSanPham'].toString()).toSet();

      results = results
          .where((product) => categoryProductIds.contains(product.maSP))
          .toList();
    }

    if (maNCC != null) {
      results = results.where((product) => product.maNCC == maNCC).toList();
    }

    return results;
  }
}
