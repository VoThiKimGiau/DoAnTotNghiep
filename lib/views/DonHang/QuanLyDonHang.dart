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
  List<String> timePeriods = ["Tất cả thời gian", "Hôm nay", "Hôm qua", "Tuần này", "Tuần trước", "Tháng này", "Tháng trước", "30 ngày", "60 ngày", "2 tháng gần đây","Tùy chọn"];
  String selectedPeriod = "Hôm nay";
  Map<String, String> _customerNames = {};
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedStatus = "Tất cả";
    tempSelectedStatus = _selectedStatus;
    selectedPeriod = "Hôm nay";
    tempSelectedPeriod = selectedPeriod;

    // Fetch orders after a brief delay to ensure widget is mounted
    Future.delayed(Duration.zero, () {
      if (mounted) {
        _fetchOrders();
      }
    });
  }

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    primary: Colors.blue,
    secondary: Colors.orange,
    surface: Colors.white,
    background: Colors.grey[100]!,
    error: Colors.red,
  );
  Future<KhachHang?> _fetchCustomerNames(String makh) async {
    KhachHangController khachHangController = KhachHangController();
    KhachHang? customer = await khachHangController.getKhachHang(makh);
    return customer;
  }
  Future<void> _showDateRangePicker(BuildContext context, StateSetter setSheetState) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setSheetState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
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
        // Decode status strings properly
        String orderStatus = utf8.decode(order.trangThaiDH.runes.toList()).trim();
        String selectedStatus = _selectedStatus.trim();

        print('Comparing status: "$orderStatus" with "$selectedStatus"'); // Debug status comparison

        bool statusMatch = selectedStatus == "Tất cả" ||
            orderStatus.toLowerCase() == selectedStatus.toLowerCase();

        DateTimeRange range = _getDateRange();
        bool dateMatch = order.ngayDat.isAfter(range.start.subtract(Duration(seconds: 1))) &&
            order.ngayDat.isBefore(range.end.add(Duration(seconds: 1)));

        print('Order ${order.maDH} - Status match: $statusMatch, Date match: $dateMatch'); // Debug matching

        return statusMatch && dateMatch;
      }).toList();

      print('Filtered orders count: ${_filteredOrders.length}'); // Debug filtered count
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
                  Text('Trạng thái đơn hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text('Khoảng thời gian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                            if (period == "Tùy chọn") {
                              _showDateRangePicker(context, setSheetState);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  if (tempSelectedPeriod == "Tùy chọn" && _startDate != null && _endDate != null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Từ: ${DateFormat('dd/MM/yyyy').format(_startDate!)} đến: ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Áp dụng'),
                    onPressed: () {
                      setState(() {
                        selectedPeriod = tempSelectedPeriod;
                        _selectedStatus = tempSelectedStatus;
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
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    if (tempSelectedPeriod == "Tùy chọn" && _startDate != null && _endDate != null) {
      // If start and end dates are the same, set time range for the entire day
      if (_startDate!.year == _endDate!.year &&
          _startDate!.month == _endDate!.month &&
          _startDate!.day == _endDate!.day) {
        start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day, 0, 0, 0);
        end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59, 999);
      } else {
        start = _startDate!;
        end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59, 999);
      }
      return DateTimeRange(start: start, end: end);
    }
    switch (tempSelectedPeriod) {
      case "Tất cả thời gian":
        start = DateTime(now.year - 99, now.month, now.day);
        break;
      case "Hôm nay":
        start = DateTime(now.year, now.month, now.day, 0, 0, 0);
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

    return DateTimeRange(start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(colorScheme: colorScheme),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Đơn hàng", style: TextStyle(color: colorScheme.onPrimary)),
          backgroundColor: colorScheme.primary,
          actions: [
            IconButton(
                icon: Icon(Icons.filter_list, color: colorScheme.onPrimary),
                onPressed: _showFilterBottomSheet
            ),
          ],
        ),
        body: Container(
          color: colorScheme.background,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: colorScheme.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Trạng thái: $_selectedStatus', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                    Text('Thời gian: $selectedPeriod', style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: colorScheme.surface,
                child: Text(
                  'Số đơn hàng: ${_filteredOrders.length}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ),
              Expanded(
                child: _filteredOrders.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Không có đơn hàng nào',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _filteredOrders[index];
                    String orderStatus = utf8.decode(order.trangThaiDH.runes.toList());
                    final sharedFunction = SharedFunction();
                    final formattedAmount = sharedFunction.formatCurrency(order.thanhTien);
                    final formattedDate = DateFormat('dd/MM/yyyy').format(order.ngayDat);

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          'Mã đơn hàng: ${order.maDH}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            FutureBuilder<KhachHang?>(
                              future: _fetchCustomerNames(order.khachHang),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Loading...', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}', style: TextStyle(color: colorScheme.error));
                                } else {
                                  return Text(
                                    'Khách hàng: ${snapshot.data?.tenKH ?? ''}\n${snapshot.data?.sdt ?? ''}',
                                    style: TextStyle(color: colorScheme.onSurface),
                                  );
                                }
                              },
                            ),

                            SizedBox(height: 4),
                            Text('Tổng tiền: $formattedAmount', style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Ngày đặt: $formattedDate', style: TextStyle(color: colorScheme.onSurface)),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(orderStatus),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                orderStatus,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        trailing: _buildActionButton(order.maDH, orderStatus),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildActionButton(String orderId, String status) {
    if (status == 'Đang xử lý') {
      return ElevatedButton.icon(
        icon: Icon(Icons.check, color: Colors.white),
        label: Text('Xác nhận', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => _updateOrderStatus(orderId, 'Đã xác nhận'),
      );
    } else if (status == 'Đã xác nhận') {
      return ElevatedButton.icon(
        icon: Icon(Icons.local_shipping, color: Colors.white),
        label: Text('Giao hàng', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => _updateOrderStatus(orderId, 'Đang giao hàng'),
      );
    }
    return null;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đang xử lý':
        return Colors.blue;
      case 'Đã xác nhận':
        return Colors.green;
      case 'Đang giao hàng':
        return Colors.orange;
      case 'Đã giao':
        return Colors.purple;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}