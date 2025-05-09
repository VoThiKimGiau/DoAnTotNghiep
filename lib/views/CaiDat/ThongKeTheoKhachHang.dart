import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DonHangController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/DonHang.dart';

class Thongketheokhachhang extends StatefulWidget {
  final String? maKH;
  const Thongketheokhachhang({Key? key, required this.maKH}) : super(key: key);

  @override
  _ThongketheokhachhangState createState() => _ThongketheokhachhangState();
}

class _ThongketheokhachhangState extends State<Thongketheokhachhang> {
  DateTime selectedDate = DateTime.now();
  Map<String, double> monthlyStats = {};
  List<DonHang> recentOrders = [];
  double growthPercentage = 0.0;
  DonHangController donHangController=DonHangController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final stats = await donHangController.calculateCustomerMonthlySpending(widget.maKH??'', selectedDate);
    final orders = await donHangController.fetchRecentOrders(widget.maKH??'');
    final growth = await donHangController.calculateSpendingGrowthPercentage(widget.maKH??'', selectedDate);

    setState(() {
      monthlyStats = stats;
      recentOrders = orders;
      growthPercentage = growth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thống kê chi tiêu',),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text('Chọn tháng: '),
                      const SizedBox(width: 10),
                      DropdownButton<DateTime>(
                        value: DateTime(selectedDate.year, selectedDate.month),
                        onChanged: (DateTime? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedDate = newValue;
                            });
                            _fetchData();
                          }
                        },
                        items: List.generate(DateTime.now().month, (index) {
                          // Lấy danh sách các tháng từ đầu năm đến tháng hiện tại
                          final date = DateTime(DateTime.now().year, index + 1);
                          return DropdownMenuItem<DateTime>(
                            value: date,
                            child: Text(DateFormat('MM/yyyy').format(date)),
                          );
                        }),
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổng chi tiêu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                            .format(monthlyStats['totalSpending'] ?? 0),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontFamily: 'Gabarito'
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${growthPercentage.toStringAsFixed(2)}% so với tháng trước',
                        style: TextStyle(
                          fontSize: 12,
                          color: growthPercentage >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Giao dịch gần đây',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              ...recentOrders.map((order) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                    child: Text(
                      order.maDH[0],
                      style: const TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                  title: Text(
                    'Đơn hàng ${order.maDH}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(order.ngayDat)),
                  trailing: Text(
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(order.thanhTien),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}


