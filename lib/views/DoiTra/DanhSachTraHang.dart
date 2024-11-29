import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/DoiTraController.dart';
import '../../models/DoiTra.dart';
import 'ReturnDetailScreen.dart';

class ReturnListScreenByCustomer extends StatefulWidget {
  final String maKH;
  ReturnListScreenByCustomer({required this.maKH});
  @override
  _ReturnListScreenByCustomerState createState() => _ReturnListScreenByCustomerState();
}

class _ReturnListScreenByCustomerState extends State<ReturnListScreenByCustomer> {
  final DoiTraController _doiTraController = DoiTraController();
  late Future<List<DoiTra>> _doiTraList;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedStatus;
  bool _isFilterVisible = false;

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    primary: Colors.blue,
    secondary: Colors.orange,
    surface: Colors.white,
    background: Colors.grey[100]!,
    error: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    _doiTraList = _doiTraController.getDoiTraListByCustomer(widget.maKH);
  }


  Widget _buildFilterDrawer() {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bộ lọc', style: TextStyle(fontSize: 24,  color: colorScheme.primary)),
              SizedBox(height: 20),
              Text('Khoảng thời gian', style: TextStyle(fontSize: 18,  color: colorScheme.onSurface)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: colorScheme,
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _startDate = picked.start;
                      _endDate = picked.end;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: colorScheme.secondary),
                child: Text(
                  _startDate != null && _endDate != null
                      ? '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}'
                      : 'Chọn khoảng thời gian',
                  style: TextStyle(color: colorScheme.onSecondary),
                ),
              ),
              SizedBox(height: 20),
              Text('Trạng thái', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedStatus,
                hint: Text('Chọn trạng thái', style: TextStyle(color: colorScheme.onSurface)),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                items: <String>['Chờ xác nhận', 'Đã xác nhận', 'Đã hoàn tiền', 'Không lọc']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: colorScheme.onSurface)),
                  );
                }).toList(),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isFilterVisible = false;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Áp dụng', style: TextStyle(color: colorScheme.onPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách trả hàng ', style: TextStyle(fontSize: 20, color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                setState(() {
                  _isFilterVisible = true;
                });
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: _buildFilterDrawer(),
      body: FutureBuilder<List<DoiTra>>(
        future: _doiTraList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}', style: TextStyle(color: colorScheme.error)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn đổi trả nào.', style: TextStyle(color: colorScheme.onBackground)));
          }

          List<DoiTra> filteredList = snapshot.data!.where((doiTra) {
            bool dateFilter = true;

            // Check if start and end date are the same
            if (_startDate != null && _endDate != null) {
              if (_startDate!.isAtSameMomentAs(_endDate!)) {
                // If start and end date are the same, filter by that specific day
                dateFilter = doiTra.ngayDoiTra != null &&
                    doiTra.ngayDoiTra!.isAfter(_startDate!.subtract(Duration(days: 1))) && // from 00:00
                    doiTra.ngayDoiTra!.isBefore(_endDate!.add(Duration(days: 1))); // till 23:59
              } else {
                // If start and end date are different, filter by range
                dateFilter = doiTra.ngayDoiTra != null &&
                    doiTra.ngayDoiTra!.isAfter(_startDate!) &&
                    doiTra.ngayDoiTra!.isBefore(_endDate!.add(Duration(days: 1)));
              }
            }

            bool statusFilter = _selectedStatus == null || _selectedStatus == 'Không lọc' || utf8.decode(doiTra.trangThai.runes.toList()) == _selectedStatus;
            return dateFilter && statusFilter;
          }).toList();


          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              DoiTra doiTra = filteredList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                color: colorScheme.surface,
                child: ListTile(
                  title: Text(
                    'Mã đổi trả: ${doiTra.maDoiTra}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đơn hàng: ${doiTra.donHang}', style: TextStyle(fontSize: 16, color: colorScheme.onSurface)),
                      Text(
                        'Trạng thái: ${utf8.decode(doiTra.trangThai.runes.toList())}',
                        style: TextStyle(fontSize: 16, color: colorScheme.secondary),
                      ),
                      Text(
                        'Ngày đổi trả: ${DateFormat('dd/MM/yyyy').format(doiTra.ngayDoiTra ?? DateTime.now())}',
                        style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
                      ),
                    ],
                  ),

                ),
              );
            },
          );
        },
      ),
    );
  }
}