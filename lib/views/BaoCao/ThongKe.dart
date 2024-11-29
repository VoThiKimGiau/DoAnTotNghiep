import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/dto/DoanhThu.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class RevenueStatisticsScreen extends StatefulWidget {
  @override
  _RevenueStatisticsScreenState createState() => _RevenueStatisticsScreenState();
}

class _RevenueStatisticsScreenState extends State<RevenueStatisticsScreen> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  List<RevenueDTO> _revenueData = [];
  bool _isLoading = false;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchRevenueData();
  }

  Future<void> _fetchRevenueData() async {
    setState(() {
      _isLoading = true;
      _selectedIndex = null;
    });

    final formatter = DateFormat('yyyy-MM-dd');
    final url = Uri.parse('${IpConfig.ipConfig}api/doanhthu/${formatter.format(_startDate)}/${formatter.format(_endDate)}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _revenueData = jsonData.map((item) => RevenueDTO.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Không thể tải dữ liệu doanh thu');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
      );
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.light(primary: Colors.blue),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _fetchRevenueData();
    }
  }

  Widget _buildChart() {
    if (_revenueData.isEmpty) {
      return Center(child: Text('Không có dữ liệu cho khoảng thời gian đã chọn.'));
    }

    double maxRevenue = _revenueData.map((data) => data.revenue).reduce((a, b) => a > b ? a : b);
    if (maxRevenue == 0) {
      return Center(child: Text('Không có dữ liệu doanh thu cho khoảng thời gian đã chọn.'));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxRevenue,
        barTouchData: BarTouchData(
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              setState(() {
                _selectedIndex = null;
              });
              return;
            }
            setState(() {
              _selectedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '',
                TextStyle(color: Colors.transparent),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % (_revenueData.length ~/ 5) == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('dd/MM').format(_revenueData[value.toInt()].date),
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  );
                }
                return Text('');
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  NumberFormat.compact().format(value),
                  style: TextStyle(color: Colors.black, fontSize: 10),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxRevenue / 5,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 1),
            left: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        barGroups: _revenueData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.revenue,
                color: _selectedIndex == entry.key ? Colors.orange : Colors.blue,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedInfo(RevenueDTO data) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('dd/MM/yyyy').format(data.date),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(data.revenue),
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biểu Đồ Doanh Thu'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text('Chọn Khoảng Thời Gian'),
            ),
          ),
          Text(
            'Từ: ${DateFormat('dd/MM/yyyy').format(_startDate)} Đến: ${DateFormat('dd/MM/yyyy').format(_endDate)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildChart(),
                ),
                if (_selectedIndex != null)
                  Positioned(
                    left: -45+(_selectedIndex! * (MediaQuery.of(context).size.width - 32) / _revenueData.length),
                    top: 16,
                    child: _buildSelectedInfo(_revenueData[_selectedIndex!]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
