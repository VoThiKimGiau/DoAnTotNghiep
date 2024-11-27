import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/DonHangController.dart';
import '../../models/DonHang.dart';
import 'package:intl/intl.dart';

class StoreReport extends StatefulWidget {
  const StoreReport({Key? key}) : super(key: key);

  @override
  _StoreReportState createState() => _StoreReportState();
}

class _StoreReportState extends State<StoreReport> {
  String selectedPeriod = "Tháng này";
  String selectedChartView = "Ngày";
  bool saveAsDefault = false;
  String tempSelectedPeriod = "Tháng này";
  List<DonHang> orders = [];
  final DonHangController _donHangController = DonHangController();
  Map<String, dynamic> statistics = {
    'totalRevenue': 0.0,
    'totalOrders': 0,
    'totalCustomers': 0,
    'cancelRate': 0.0,
    'avgOrdersPerCustomer': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String _formatChartDate(DateTime date) {
    switch (selectedChartView) {
      case "Giờ":
        return '${date.hour}:00';
      case "Tuần":
        return 'Tuần ${((date.day - 1) ~/ 7) + 1}';
      case "Tháng":
        return '${date.month}/${date.year}';
      default: // "Ngày"
        return '${date.day}/${date.month}';
    }
  }

  List<String> _getAvailableChartViews() {
    switch (selectedPeriod) {
      case "Hôm nay":
      case "Hôm qua":
        return ["Giờ"];
      case "Tuần này":
      case "Tuần trước":
      case "Tháng này":
      case "Tháng trước":
      case "30 ngày":
      case "60 ngày":
        return ["Ngày", "Tuần"];
      case "Tất cả thời gian":
        return ["Ngày", "Tuần", "Tháng"];
      default:
        return ["Ngày"];
    }
  }


  Future<void> _loadData() async {
    try {
      DateTimeRange dateRange = _getDateRange();
      String startDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateRange.start);
      String endDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateRange.end);

      orders = await _donHangController.fetchDonHangByDateRange(startDate, endDate);
      print(orders);
      setState(() {
        statistics = _donHangController.calculateStatistics(orders);
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }


  String formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(1);
  }
  List<FlSpot> _generateChartData() {
    Map<DateTime, double> groupedRevenue = {};

    orders.sort((a, b) => a.ngayDat!.compareTo(b.ngayDat!));

    switch (selectedChartView) {
      case "Giờ":
        for (var order in orders) {
          if (order.ngayDat != null && order.thanhTien != null && order.trangThaiDH != 'canceled') {
            DateTime hourKey = DateTime(
              order.ngayDat!.year,
              order.ngayDat!.month,
              order.ngayDat!.day,
              order.ngayDat!.hour,
            );
            groupedRevenue[hourKey] = (groupedRevenue[hourKey] ?? 0) + order.thanhTien!;
          }
        }
        break;

      case "Tuần":
      case "Tháng":
      case "Ngày":
        for (var order in orders) {
          if (order.ngayDat != null && order.thanhTien != null && order.trangThaiDH != 'canceled') {
            DateTime dayKey = DateTime(
              order.ngayDat!.year,
              order.ngayDat!.month,
              order.ngayDat!.day,
            );
            groupedRevenue[dayKey] = (groupedRevenue[dayKey] ?? 0) + order.thanhTien!;
          }
        }
        break;
    }

    var sortedDates = groupedRevenue.keys.toList()..sort();
    var filteredDates = sortedDates.where((date) => groupedRevenue[date]! > 0).toList();

    return List.generate(filteredDates.length, (index) {
      return FlSpot(
          index.toDouble(),
          groupedRevenue[filteredDates[index]]! / 1000 // Convert to thousands for better display
      );
    });
  }


  void _showFilterBottomSheet() {
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
                      Text(
                        'Bộ lọc',
                        style: TextStyle(
                          fontSize: 20,

                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Khoảng thời gian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip('Tất cả thời gian', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('Hôm nay', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('Hôm qua', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('Tuần này', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('Tuần trước', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('Tháng này', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('Tháng trước', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('2 tháng gần đây', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('Thời gian khác', tempSelectedPeriod, setSheetState),
                    ],
                  ),
                  SizedBox(height: 16),
                  CheckboxListTile(
                    title: Text('Lưu bộ lọc làm mặc định'),
                    value: saveAsDefault,
                    onChanged: (bool? value) {
                      setSheetState(() {
                        saveAsDefault = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],

                            foregroundColor: Colors.black,
                          ),
                          child: Text('Đặt về mặc định'),
                          onPressed: () {
                            setSheetState(() {
                              tempSelectedPeriod = "Tháng này";
                              saveAsDefault = false;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Áp dụng'),
                          onPressed: () {
                            setState(() {
                              selectedPeriod = tempSelectedPeriod;
                            });
                            Navigator.pop(context);
                            _loadData();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String currentSelection, StateSetter setSheetState) {
    bool isSelected = currentSelection == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setSheetState(() {
          tempSelectedPeriod = selected ? label : tempSelectedPeriod;
        });
      },
      selectedColor: Colors.green,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
      backgroundColor: Colors.grey[200],
    );
  }
  List<FlSpot> _generateMonthlyRevenueData() {
    Map<int, double> dailyRevenue = {};

    for (var order in orders) {
      if (order.ngayDat != null && order.thanhTien != null && utf8.decode (order.trangThaiDH.runes.toList()) != 'Đã huỷ') {
        int day = order.ngayDat!.day;
        dailyRevenue[day] = (dailyRevenue[day] ?? 0) + order.thanhTien!;
      }
    }

    List<FlSpot> spots = [];
    for (int i = 1; i <= 31; i += 5) {
      double revenue = 0;
      for (int j = i; j < i + 5 && j <= 31; j++) {
        revenue += dailyRevenue[j] ?? 0;
      }
      spots.add(FlSpot(i.toDouble(), revenue / 1000000));
    }

    return spots;
  }
  DateTimeRange _getDateRange() {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    switch (selectedPeriod) {
      case "Tất cả thời gian":
        start = DateTime(now.year-99, now.month, now.day);
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
      case "2 Tháng gần đây":
        start = DateTime(now.year, now.month - 2, 1);
        break;
      default:
        start = DateTime(now.year, now.month, 1);
    }
    return DateTimeRange(start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final availableChartViews = _getAvailableChartViews();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Báo cáo cửa hàng',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text(selectedPeriod),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
                onPressed: _showFilterBottomSheet,
              ),
            ),
            // Metrics grid with larger chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                children: [
                  // First 5 metric cards
                  ...List.generate(5, (index) => _buildMetricCard(
                      ['Doanh thu', 'Đơn hàng', 'Trung bình đơn', 'Tổng khách hàng', 'TB Đơn/Khách'][index],
                      [
                        currencyFormat.format(statistics['totalRevenue']),
                        statistics['totalOrders'].toString(),
                        statistics['totalOrders'] > 0
                            ? currencyFormat.format(statistics['totalRevenue'] / statistics['totalOrders'])
                            : '0đ',
                        statistics['totalCustomers'].toString(),
                        statistics['avgOrdersPerCustomer'].toStringAsFixed(1)
                      ][index],
                      [Icons.trending_up, Icons.shopping_cart, Icons.analytics, Icons.people, Icons.person][index],
                      Colors.green
                  )),
                  _buildMetricCard(
                      'Tỉ lệ huỷ đơn',
                      '${statistics['cancelRate'].toStringAsFixed(1)}%',
                      Icons.cancel,
                      Colors.red
                  ),
                ],
              ),
            ),

            // Large Chart Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doanh Thu Theo Thời Gian',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      AspectRatio(
                        aspectRatio: 1.5, // Increased aspect ratio for wider chart
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: false,
                              horizontalInterval: 1,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.withOpacity(0.2),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                        '${value.toInt()}M',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600]
                                        )
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          '${value.toInt()}',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[600]
                                          )
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _generateMonthlyRevenueData(),
                                isCurved: true,
                                color: Colors.green,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.withOpacity(0.8),
                                    Colors.green.withOpacity(0.3),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: Colors.white,
                                      strokeWidth: 2,
                                      strokeColor: Colors.green,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.withOpacity(0.3),
                                      Colors.green.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(icon, color: color),
            ),
          ],
        ),
      ),
    );
  }
}