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
  List<DonHang> orders=[];
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

  Widget _buildChartToggle(String text) {
    bool isSelected = selectedChartView == text;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () {
        setState(() {
          selectedChartView = text;
        });
      },
      child: Text(text),
    );
  }
  Future<void> _loadData() async {
    try {
      // Get date range based on selected period
      DateTimeRange dateRange = _getDateRange();
      String startDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateRange.start);
      String endDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateRange.end);

      // Fetch orders
       orders = await _donHangController.fetchDonHangByDateRange(startDate, endDate);
      print(orders);
      // Calculate statistics
      setState(() {
        statistics = _donHangController.calculateStatistics(orders);
      });
    } catch (e) {
      print('Error loading data: $e');
      // You might want to show an error message to the user
    }
  }
  List<FlSpot> _generateChartData() {
    // Group orders by date and sum their revenue
    Map<DateTime, double> dailyRevenue = {};

    for (var order in orders) {
      if (order.ngayDat != null && order.thanhTien != null && order.trangThaiDH != 'canceled') {
        DateTime orderDate = DateTime(
          order.ngayDat!.year,
          order.ngayDat!.month,
          order.ngayDat!.day,
        );
        dailyRevenue[orderDate] = (dailyRevenue[orderDate] ?? 0) + order.thanhTien!;
      }
    }

    // Sort dates
    var sortedDates = dailyRevenue.keys.toList()..sort();

    // Create spots for the chart
    return sortedDates.asMap().entries.map((entry) {
      return FlSpot(
          entry.key.toDouble(),
          dailyRevenue[entry.value]! / 1000 // Convert to thousands for better display
      );
    }).toList();
  }

  Widget _buildRevenueChart() {
    final spots = _generateChartData();
    if (spots.isEmpty) {
      return Center(
        child: Text('Không có dữ liệu'),
      );
    }

    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1000,
            verticalInterval: 5,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  if (spots.isEmpty || value.toInt() >= spots.length) {
                    return Text('');
                  }
                  DateTime date = DateTime.now().subtract(
                      Duration(days: spots.length - 1 - value.toInt())
                  );
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1000,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${NumberFormat.compact().format(value)}k',
                    style: TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.black12),
              left: BorderSide(color: Colors.black12),
            ),
          ),
          minX: 0,
          maxX: spots.length.toDouble() - 1,
          minY: 0,
          maxY: spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.green,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final DateTime date = DateTime.now().subtract(
                      Duration(days: spots.length - 1 - touchedSpot.x.toInt())
                  );
                  return LineTooltipItem(
                    '${DateFormat('dd/MM/yyyy').format(date)}\n',
                    const TextStyle(color: Colors.white, fontSize: 12),
                    children: [
                      TextSpan(
                        text: '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(touchedSpot.y * 1000)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    // Set temporary selection to current selection when opening sheet
    tempSelectedPeriod = selectedPeriod;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow bottom sheet to be larger
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
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bộ lọc',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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

                  // Time period options with temporary state
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
                      _buildFilterChip('30 ngày', tempSelectedPeriod, setSheetState),
                      _buildFilterChip('60 ngày', tempSelectedPeriod, setSheetState),
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
                            // Update main state with temporary selection
                            setState(() {
                              selectedPeriod = tempSelectedPeriod;
                            });
                            Navigator.pop(context);
                            _loadData(); // Reload data with new period
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
      case "30 ngày":
        start = now.subtract(Duration(days: 29));
        break;
      case "60 ngày":
        start = now.subtract(Duration(days: 59));
        break;
      default:
        start = DateTime(now.year, now.month, 1);
    }
    return DateTimeRange(start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

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
      // Remove the Expanded widget from inside SingleChildScrollView
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


            // Metrics grid
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.all(8),
              childAspectRatio: 1.5,
              children: [
                _buildMetricCard(
                    'Doanh thu',
                    currencyFormat.format(statistics['totalRevenue']),
                    Icons.trending_up,
                    Colors.green
                ),
                _buildMetricCard(
                    'Đơn hàng',
                    statistics['totalOrders'].toString(),
                    Icons.shopping_cart,
                    Colors.green
                ),
                _buildMetricCard(
                    'Trung bình đơn',
                    statistics['totalOrders'] > 0
                        ? currencyFormat.format(statistics['totalRevenue'] / statistics['totalOrders'])
                        : '0đ',
                    Icons.analytics,
                    Colors.green
                ),
                _buildMetricCard(
                    'Tổng khách hàng',
                    statistics['totalCustomers'].toString(),
                    Icons.people,
                    Colors.green
                ),
                _buildMetricCard(
                    'TB Đơn/Khách',
                    statistics['avgOrdersPerCustomer'].toStringAsFixed(1),
                    Icons.person,
                    Colors.green
                ),
                _buildMetricCard(
                    'Tỉ lệ huỷ đơn',
                    '${statistics['cancelRate'].toStringAsFixed(1)}%',
                    Icons.cancel,
                    Colors.red
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChartToggle('Ngày')
              ],
            ),
            Container(
              height: 300,
              child: _buildRevenueChart(),
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
                    fontWeight: FontWeight.bold,
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