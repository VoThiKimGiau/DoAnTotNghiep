import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/DonHangController.dart';
import '../../controllers/KhachHangController.dart';
import '../../models/DonHang.dart';
import '../../models/KhachHang.dart';
import '../../services/shared_function.dart';

class TodaysOrdersScreen extends StatefulWidget {
  @override
  _TodaysOrdersScreenState createState() => _TodaysOrdersScreenState();
}

class _TodaysOrdersScreenState extends State<TodaysOrdersScreen> {
  final DonHangController _donHangController = DonHangController();
  List<DonHang> _orders = [];
  List<DonHang> _filteredOrders = [];
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'Tất cả';
  String tempSelectedStatus = "Tất cả";
  String tempSelectedPeriod = "Hôm nay";
  List<String> orderStatuses = ["Tất cả", "Đang xử lý", "Đã xác nhận", "Đã giao", "Đã hủy"];
  List<String> timePeriods = ["Tất cả thời gian", "Hôm nay", "Hôm qua", "Tuần này", "Tuần trước", "Tháng này", "Tháng trước", "30 ngày", "60 ngày", "2 tháng gần đây"];
  String selectedPeriod = "Hôm nay";
  Map<String, String> _customerNames = {};
  @override
  void initState() {
    super.initState();
    _fetchOrders();
    tempSelectedStatus = _selectedStatus;
  }
  Future<void> _fetchCustomerNames() async {
    KhachHangController khachHangController = KhachHangController();

    for (var order in _filteredOrders) {
      if (order.khachHang.isNotEmpty && !_customerNames.containsKey(order.khachHang)) {
        KhachHang? customer = await khachHangController.getKhachHang(order.khachHang);
        if (customer != null) {
          setState(() {
            _customerNames[order.khachHang] = customer.tenKH; // Assuming hoTen is the name field
          });
        }
      }
    }
  }

  void _updateOrderStatus(String madh, String trangThai) async {
    bool success = await _donHangController.updateOrderStatus(madh, trangThai);
    if (success) {
      print('Order status updated successfully');
      _fetchOrders();
    } else {
      print('Failed to update order status');
    }
  }

  Future<void> _fetchOrders() async {
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final DateTimeRange dateRange = _getDateRange();
    final String startDate = formatter.format(dateRange.start);
    final String endDate = formatter.format(dateRange.end);

    try {
      final fetchedOrders = await _donHangController.fetchDonHangByDateRange(startDate, endDate);
      setState(() {
        _orders = fetchedOrders;
        _filterOrders();
      });
    } catch (error) {
      print('Failed to fetch orders: $error');
    }
  }

  void _filterOrders() {
    setState(() {
      _filteredOrders = _orders.where((order) {
        // Decode trạng thái từ đơn hàng
        String orderStatus = utf8.decode(order.trangThaiDH.runes.toList()).trim();

        // Decode selected status để đảm bảo cùng encoding
        String selectedStatus = _selectedStatus.trim();

        // So sánh sau khi đã normalize cả hai chuỗi
        bool statusMatch = selectedStatus == "Tất cả" ||
            orderStatus.toLowerCase() == selectedStatus.toLowerCase();

        // Lọc theo thời gian
        bool dateMatch = _getDateRange().start.isBefore(order.ngayDat) &&
            _getDateRange().end.isAfter(order.ngayDat);

        // In ra để debug
        print('Order Status: $orderStatus');
        print('Selected Status: $selectedStatus');
        print('Status Match: $statusMatch');

        return statusMatch && dateMatch;
      }).toList();
    });
  }
  void _handleStatusChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedStatus = newValue;
        _filterOrders();
      });
    }
  }


  void _showFilterBottomSheet() {
    // Reset temporary values to current selections
    tempSelectedStatus = _selectedStatus;
    tempSelectedPeriod = selectedPeriod;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bộ lọc', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context)
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Trạng thái đơn hàng',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: orderStatuses.map((status) {
                      bool isSelected = tempSelectedStatus == status;
                      return ChoiceChip(
                        label: Text(status),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setSheetState(() {
                            tempSelectedStatus = status;
                            print('Temporary status selected: $status');
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text('Khoảng thời gian',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: timePeriods.map((period) {
                      bool isSelected = tempSelectedPeriod == period;
                      return ChoiceChip(
                        label: Text(period),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setSheetState(() {
                            tempSelectedPeriod = period;
                            print('Temporary period selected: $period');
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Áp dụng'),
                    onPressed: () {
                      setState(() {
                        selectedPeriod = tempSelectedPeriod;
                        _selectedStatus = tempSelectedStatus;
                        print('Applied filters - Status: $_selectedStatus, Period: $selectedPeriod');
                        _fetchOrders();

                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  DateTimeRange _getDateRange() {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    switch (tempSelectedPeriod) {
      case "Tất cả thời gian":
        start = DateTime(now.year - 99, now.month, now.day);
        break;
      case "Hôm nay":
        start = DateTime(now.year, now.month, now.day);
        break;
      case "Hôm qua":
        start = DateTime(now.year, now.month, now.day - 1);
        end = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
        break;
      case "Tuần này":
        start = now.subtract(Duration(days: now.weekday - 1));
        break;
      case "Tuần trước":
        start = now.subtract(Duration(days: now.weekday + 6));
        end = now.subtract(Duration(days: now.weekday));
        break;
      case "Tháng này":
        start = DateTime(now.year, now.month, 1);
        break;
      case "Tháng trước":
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 0, 23, 59, 59);
        break;
      case "30 ngày":
        start = now.subtract(Duration(days: 30));
        break;
      case "60 ngày":
        start = now.subtract(Duration(days: 60));
        break;
      case "2 tháng gần đây":
        start = DateTime(now.year, now.month - 2, 1);
        break;
      default:
        start = DateTime(now.year, now.month, now.day);
    }

    print('Date range - Start: $start, End: $end');
    return DateTimeRange(start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đơn hàng hôm nay"),
        actions: [
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: _showFilterBottomSheet
          ),
        ],
      ),
      body: Column(
        children: [
          // Added status information display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trạng thái: $_selectedStatus'),
                Text('Thời gian: $selectedPeriod'),
              ],
            ),
          ),
          // Added count display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Số đơn hàng: ${_filteredOrders.length}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                String orderStatus = utf8.decode(order.trangThaiDH.runes.toList());
                final sharedFunction = SharedFunction();
                final formattedAmount = sharedFunction.formatCurrency(order.thanhTien);
                final formattedDate = DateFormat('dd/MM/yyyy').format(order.ngayDat);
                String customerName = _customerNames[order.khachHang] ?? 'Unknown';

                return ListTile(
                  title: Text('Mã đơn hàng: ${order.maDH}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Khách hàng: $customerName'),
                      Text('Tổng tiền: $formattedAmount'),
                      Text('Ngày đặt: $formattedDate'),
                    ],
                  ),
                  trailing: orderStatus == 'Đang xử lý'
                      ? IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () => _updateOrderStatus(order.maDH, 'Đã xác nhận'),
                  )
                      : null,
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}