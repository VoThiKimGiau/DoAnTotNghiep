import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDrawer extends StatefulWidget {
  final Function(String?) onStatusFilterChanged;
  final Function(DateTime?, DateTime?) onDateFilterChanged;

  const FilterDrawer({
    Key? key,
    required this.onStatusFilterChanged,
    required this.onDateFilterChanged,
  }) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  String? selectedStatus;
  String? selectedDateFilter;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bộ lọc',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          applyFilters();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ExpansionTile(
                  title: Text('Trạng thái'),
                  children: [
                    RadioListTile<String>(
                      title: Text('Đang xử lý'),
                      value: 'Đang xử lý',
                      groupValue: selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Đã nhận hàng'),
                      value: 'Đã nhận hàng',
                      groupValue: selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text('Thời gian'),
                  children: [
                    RadioListTile<String>(
                      title: Text('Hôm nay'),
                      value: 'today',
                      groupValue: selectedDateFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedDateFilter = value;
                          _setDateRange('today');
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Hôm qua'),
                      value: 'yesterday',
                      groupValue: selectedDateFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedDateFilter = value;
                          _setDateRange('yesterday');
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Tuần trước'),
                      value: 'lastWeek',
                      groupValue: selectedDateFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedDateFilter = value;
                          _setDateRange('lastWeek');
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Khác'),
                      value: 'custom',
                      groupValue: selectedDateFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedDateFilter = value;
                        });
                        _showDateRangePicker();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                applyFilters();
                Navigator.pop(context);
              },

              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('Áp dụng')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setDateRange(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = now;
        break;
      case 'yesterday':
        final yesterday = now.subtract(Duration(days: 1));
        startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        endDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case 'lastWeek':
        startDate = now.subtract(Duration(days: 7));
        endDate = now;
        break;
    }
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now(),
        end: endDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  void applyFilters() {
    widget.onStatusFilterChanged(selectedStatus);
    widget.onDateFilterChanged(startDate, endDate);
  }
}