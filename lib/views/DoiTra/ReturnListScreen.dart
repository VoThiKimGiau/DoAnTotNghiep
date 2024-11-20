import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/DoiTraController.dart';
import '../../models/DoiTra.dart';
import 'ReturnDetailScreen.dart';

class ReturnListScreen extends StatefulWidget {
  @override
  _ReturnListScreenState createState() => _ReturnListScreenState();
}

class _ReturnListScreenState extends State<ReturnListScreen> {
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
    _doiTraList = _doiTraController.getDoiTraList();
  }

  Future<void> _showConfirmDialog(DoiTra doiTra) async {
    DateTime? selectedDate;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Xác nhận đổi trả', style: TextStyle(color: colorScheme.primary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Chọn ngày lấy hàng:', style: TextStyle(color: colorScheme.onSurface)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
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
                      if (date != null) {
                        setStateDialog(() {
                          selectedDate = date;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: colorScheme.secondary),
                    child: Text('Chọn ngày', style: TextStyle(color: colorScheme.onSecondary)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    selectedDate == null
                        ? 'Chưa chọn ngày'
                        : 'Ngày đã chọn: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                    style: TextStyle(fontSize: 16, color: colorScheme.primary),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy', style: TextStyle(color: colorScheme.error)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedDate != null) {
                      try {
                        doiTra.trangThai = 'Đã xác nhận';
                        doiTra.lyDo = utf8.decode(doiTra.lyDo.runes.toList());
                        doiTra.ngayXacNhan = DateTime.now();
                        doiTra.ngayTraHang = selectedDate;
                        await _doiTraController.updateDoiTra(doiTra.maDoiTra!, doiTra);
                        setState(() {
                          _doiTraList = _doiTraController.getDoiTraList();
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Xác nhận đổi trả thành công!'),
                            backgroundColor: colorScheme.secondary,
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi khi xác nhận đổi trả: $e'),
                            backgroundColor: colorScheme.error,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vui lòng chọn ngày lấy hàng!'),
                          backgroundColor: colorScheme.error,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
                  child: Text('Xác nhận', style: TextStyle(color: colorScheme.onPrimary)),
                ),
              ],
            );
          },
        );
      },
    );
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
        title: Text('Quản lý danh sách trả hàng hoàn tiền', style: TextStyle(fontSize: 20, color: colorScheme.onPrimary)),
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
                  trailing: (utf8.decode(doiTra.trangThai.runes.toList()) == "Đã xác nhận" ||
                      utf8.decode(doiTra.trangThai.runes.toList()) == "Đã hoàn tiền")
                      ? null
                      : IconButton(
                    icon: Icon(Icons.check, color: colorScheme.secondary),
                    onPressed: () => _showConfirmDialog(doiTra),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReturnDetailScreen(doiTra: doiTra),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}