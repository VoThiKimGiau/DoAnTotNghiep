import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../config/IpConfig.dart';
import '../models/DonHang.dart';

class DonHangController {
  Future<List<DonHang>> fetchDonHang(String? maKH) async {
    final response = await http.get(
      Uri.parse('http://${IpConfig.ipConfig}/api/donhang/byCustomer?maKH=$maKH'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((donHang) => DonHang.fromJson(donHang)).toList();
    } else {
      throw Exception('Failed to load DonHang');
    }
  }
  Future<DonHang> fetchDetailDonHang(String? maDH) async {
    final response = await http.get(
      Uri.parse('http://${IpConfig.ipConfig}/api/donhang/$maDH'),
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return DonHang.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load DonHang');
    }
  }
  Future<List<DonHang>> fetchDonHangByDateRange(String startDate, String endDate) async {
    final String url =
        'http://${IpConfig
        .ipConfig}/api/donhang/by-date-range?startDate=$startDate&endDate=$endDate';


    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DonHang.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load DonHang');
    }
  }
  Map<String, dynamic> calculateStatistics(List<DonHang> donHangList) {

    List<DonHang> validOrders = donHangList.where((order) => order.trangThaiDH != 'canceled').toList();


    double totalRevenue = validOrders.fold(0.0, (sum, order) => sum + (order.thanhTien ?? 0.0));

    int totalOrders = donHangList.length;

    int totalCustomers = donHangList.map((order) => order.khachHang).toSet().length;

    int canceledOrdersCount = donHangList.where((order) => order.trangThaiDH == 'canceled').length;
    double cancelRate = (totalOrders > 0) ? (canceledOrdersCount / totalOrders) * 100 : 0.0;

    // Tính trung bình đơn hàng trên mỗi khách hàng
    double avgOrdersPerCustomer = (totalCustomers > 0) ? totalOrders / totalCustomers : 0.0;

    return {
      'totalRevenue': totalRevenue,
      'totalOrders': totalOrders,
      'totalCustomers': totalCustomers,
      'cancelRate': cancelRate,
      'avgOrdersPerCustomer': avgOrdersPerCustomer,
    };
  }
  Future<Map<String, dynamic>> calculateTodayStatistics() async {
    DateTime today = DateTime.now();
    DateTime start = DateTime(today.year, today.month, today.day);
    DateTime end = DateTime(today.year, today.month, today.day, 23, 59, 59);
    String startDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(start);
    String endDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(end);

    List<DonHang> donHangListToday = await fetchDonHangByDateRange(startDate,endDate);

    int processingOrdersCount = donHangListToday
        .where((order) => utf8.decode(order.trangThaiDH.runes.toList()) == 'Đang xử lý')
        .length;
    int todayOrdersCount = donHangListToday.length;
    int doneOrdersCount=donHangListToday
        .where((order) => utf8.decode(order.trangThaiDH.runes.toList()) == 'Đã giao hàng')
        .length;
    double totalRevenue = donHangListToday
        .where((order) =>
    utf8.decode(order.trangThaiDH.runes.toList()) != 'Đã huỷ')
        .fold(0.0, (sum, order) => sum + (order.thanhTien ?? 0.0));
    return {
      'totalRevenue':totalRevenue,
      'doneOrdersCount':doneOrdersCount,
      'processingOrders': processingOrdersCount,
      'todayOrders': todayOrdersCount,
    };
  }

}
