import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietDonHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../config/IpConfig.dart';
import '../models/ChiTietDonHang.dart';
import '../models/ChiTietPhieuNhap.dart';
import '../models/DonHang.dart';
import 'NhanVienController.dart';

class DonHangController {
  ChiTietDonHangController chiTietDonHangController=ChiTietDonHangController();
  ChiTietPhieuNhapController chiTietPhieuNhapController=ChiTietPhieuNhapController();
  Future<List<DonHang>> fetchDonHang(String? maKH, {String? status, DateTime? date}) async {
    final response = await http.get( Uri.parse('${IpConfig.ipConfig}api/donhang/byCustomer?maKH=$maKH'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<DonHang> donHangs = jsonResponse.map((item) => DonHang.fromJson(item)).toList();

      // Apply filters
      if (status != null) {
        donHangs = donHangs.where((donHang) => utf8.decode(donHang.trangThaiDH.runes.toList()) == status).toList();
      }
      if (date != null) {
        donHangs = donHangs.where((donHang) =>
        donHang.ngayDat.year == date.year &&
            donHang.ngayDat.month == date.month &&
            donHang.ngayDat.day == date.day
        ).toList();
      }

      return donHangs;
    } else {
      throw Exception('Failed to load don hang');
    }
  }

  Future<DonHang> fetchDetailDonHang(String? maDH) async {
    final response = await http.get(
      Uri.parse('${IpConfig.ipConfig}api/donhang/$maDH'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return DonHang.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load DonHang');
    }
  }
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    final String apiUrl = '${IpConfig.ipConfig}api/donhang/$orderId';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // Thêm charset
          'Accept': 'application/json',
        },
        body: newStatus,
      );

      if (response.statusCode == 200) {
        // Cập nhật thành công
        return true;
      } else {
        // Thất bại, bạn có thể xử lý thêm ở đây
        print('Failed to update status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating status: $e');
      return false;
    }
  }
  Future<List<DonHang>> fetchDonHangByDateRange(String startDate, String endDate) async {

    NhanVienController nhanVienController=NhanVienController();
    String? token = await nhanVienController.getToken();

    // Nếu không có token, throw một exception
    if (token == null) {
      throw Exception("Token không tồn tại");
    }


    final String url =
        '${IpConfig.ipConfig}api/donhang/by-date-range?startDate=$startDate&endDate=$endDate';


    final response = await http.get(Uri.parse(url),headers: {
      'Content-Type': 'application/json; charset=UTF-8', // Thêm charset
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },);

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
    double profit=totalRevenue-await calculateTotalCostToday();
    return {
      'totalRevenue':totalRevenue,
      'doneOrdersCount':doneOrdersCount,
      'processingOrders': processingOrdersCount,
      'todayOrders': todayOrdersCount,
      'profit':profit
    };
  }
  Future<double> calculateTotalCostToday() async {
    DateTime today = DateTime.now();
    DateTime start = DateTime(today.year, today.month, today.day);
    DateTime end = DateTime(today.year, today.month, today.day, 23, 59, 59);
    String startDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(start);
    String endDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(end);

    // Bước 1: Lấy danh sách đơn hàng hôm nay
    List<DonHang> donHangListToday = await fetchDonHangByDateRange(startDate, endDate);
    
    double totalCost = 0.0;

    // Bước 2: Lặp qua từng đơn hàng hôm nay để tính tổng giá trị vốn
    for (DonHang donHang in donHangListToday) {
      List<ChiTietDonHang> listChiTietDonHang= await chiTietDonHangController.fetchListProduct(donHang.maDH);
      for (ChiTietDonHang chiTiet in listChiTietDonHang) {
        // Lấy `maCTSP` từ chi tiết đơn hàng
        String maCTSP = chiTiet.sanPham;

        // Tìm phiếu nhập có cùng `maCTSP`
        ChiTietPhieuNhap? phieuNhap = await findMatchingPhieuNhap(maCTSP);

        if (phieuNhap != null) {
          // Tính giá vốn cho chi tiết này
          double cost = chiTiet.soLuong * phieuNhap.donGia;
          totalCost += cost;
        }
      }
    }

    return totalCost;
  }

// Hàm trợ giúp để tìm ChiTietPhieuNhap theo maCTSP
  Future<ChiTietPhieuNhap?> findMatchingPhieuNhap(String maCTSP) async {
    // Giả định bạn có hàm fetchPhieuNhapList để lấy tất cả các phiếu nhập
    List<ChiTietPhieuNhap> phieuNhapList = await chiTietPhieuNhapController.layDanhSachChiTietPhieuNhap("");

    // Tìm ChiTietPhieuNhap đầu tiên khớp với maCTSP
    for (ChiTietPhieuNhap phieuNhap in phieuNhapList) {
      if (phieuNhap.maCTSP == maCTSP) {
        return phieuNhap;
      }
    }
    return null;
  }
  Future<Map<String, double>> calculateCustomerMonthlySpending(String maKH, DateTime date) async {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59);

    String startDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(firstDayOfMonth);
    String endDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(lastDayOfMonth);

    List<DonHang> customerOrders = await fetchDonHang(maKH);

    List<DonHang> monthlyOrders = customerOrders.where((order) {
      return order.ngayDat.isAfter(firstDayOfMonth) &&
          order.ngayDat.isBefore(lastDayOfMonth);
    }).toList();

    double totalSpending = monthlyOrders
        .where((order) => utf8.decode(order.trangThaiDH.runes.toList()) != 'Đã huỷ')
        .fold(0.0, (sum, order) => sum + (order.thanhTien ?? 0.0));

    int successfulOrders = monthlyOrders
        .where((order) => utf8.decode(order.trangThaiDH.runes.toList()) == 'Đã giao hàng')
        .length;


    int canceledOrders = monthlyOrders
        .where((order) => utf8.decode(order.trangThaiDH.runes.toList()) == 'Đã huỷ')
        .length;

    double averageSpendingPerOrder = successfulOrders > 0
        ? totalSpending / successfulOrders
        : 0.0;

    return {
      'totalSpending': totalSpending,
      'averageSpendingPerOrder': averageSpendingPerOrder,
      'successfulOrders': successfulOrders.toDouble(),
      'canceledOrders': canceledOrders.toDouble(),
    };
  }
  Future<List<DonHang>> fetchRecentOrders(String maKH, {int limit = 3}) async {

    List<DonHang> allOrders = await fetchDonHang(maKH);

    allOrders.sort((a, b) => b.ngayDat.compareTo(a.ngayDat));

    return allOrders.take(limit).toList();
  }
  Future<double> calculateSpendingGrowthPercentage(String maKH, DateTime currentDate) async {

    Map<String, double> currentMonthStats = await calculateCustomerMonthlySpending(
        maKH,
        currentDate
    );


    DateTime previousMonth = DateTime(
      currentDate.month == 1 ? currentDate.year - 1 : currentDate.year,
      currentDate.month == 1 ? 12 : currentDate.month - 1,
    );


    Map<String, double> previousMonthStats = await calculateCustomerMonthlySpending(
        maKH,
        previousMonth
    );


    double currentMonthSpending = currentMonthStats['totalSpending'] ?? 0.0;
    double previousMonthSpending = previousMonthStats['totalSpending'] ?? 0.0;


    if (previousMonthSpending > 0) {
      return ((currentMonthSpending - previousMonthSpending) / previousMonthSpending) * 100;
    }

    return 0.0;
  }

}
