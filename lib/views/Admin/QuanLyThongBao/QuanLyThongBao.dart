import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/views/Admin/QuanLyThongBao/GanTB.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/QuanLyThongBao/ThemThongBao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ThongBaoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/TBKHController.dart';
import 'package:datn_cntt304_bandogiadung/models/ThongBao.dart';
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';
import 'package:datn_cntt304_bandogiadung/models/TBKH.dart';

class NotificationManagementScreen extends StatefulWidget {
  @override
  _NotificationManagementScreenState createState() => _NotificationManagementScreenState();
}

class _NotificationManagementScreenState extends State<NotificationManagementScreen> {
  final ThongBaoController _thongBaoController = ThongBaoController();
  final KhachHangController _khachHangController = KhachHangController();
  final TBKHController _tbkhController = TBKHController();
  List<ThongBao> _notifications = [];
  List<ThongBao> _filteredNotifications = [];
  DateTime? _selectedDate;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() async {
    try {
      List<ThongBao> thongBaoList = await _thongBaoController.fetchAllThongBao();
      setState(() {
        _notifications = thongBaoList;
        _filteredNotifications = _notifications;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi tải thông báo')),
      );
    }
  }

  void _filterNotifications() {
    setState(() {
      _filteredNotifications = _notifications.where((notification) {
        bool dateMatch = _selectedDate == null ||
            DateFormat('yyyy-MM-dd').format(notification.ngayTB) == DateFormat('yyyy-MM-dd').format(_selectedDate!);
        bool nameMatch = notification.noiDung.toLowerCase().contains(_searchController.text.toLowerCase());
        return dateMatch && nameMatch;
      }).toList();
    });
  }

  void _openCustomerSelectionDialog(ThongBao thongBao) async {
    try {
      List<KhachHang> allCustomers = await _khachHangController.fetchAllCustomer();
      List<TBKH> existingTBKHs = await _tbkhController.getAllTBKH();

      List<KhachHang> eligibleCustomers = allCustomers.where((customer) {
        return !existingTBKHs.any((tbkh) => tbkh.khachHang == customer.maKH && tbkh.maTBKH.startsWith(thongBao.maTB));
      }).toList();

      final List<KhachHang>? selectedCustomers = await showDialog<List<KhachHang>>(
        context: context,
        builder: (BuildContext context) {
          return CustomerSelectionDialog(customers: eligibleCustomers);
        },
      );

      if (selectedCustomers != null && selectedCustomers.isNotEmpty) {
        _createTBKHForSelectedCustomers(thongBao, selectedCustomers);
      }
    } catch (e) {
      print('Error opening customer selection dialog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi mở danh sách khách hàng')),
      );
    }
  }

  void _createTBKHForSelectedCustomers(ThongBao thongBao, List<KhachHang> selectedCustomers) async {
    for (var customer in selectedCustomers) {
      try {
        TBKH newTBKH = TBKH(
          maTBKH: '${thongBao.maTB}_${customer.maKH}',
          khachHang: customer.maKH,
          daXem: false,
        );
        await _tbkhController.createTBKH(newTBKH);
      } catch (e) {
        print('Error creating TBKH for customer ${customer.maKH}: $e');
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã tạo thông báo cho ${selectedCustomers.length} khách hàng')),
    );
  }

  void _editNotification(ThongBao thongBao) async {
    final TextEditingController _editController = TextEditingController(text: thongBao.noiDung);
    final updatedContent = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sửa mô tả thông báo'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(hintText: "Nhập mô tả mới"),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () => Navigator.of(context).pop(_editController.text),
            ),
          ],
        );
      },
    );

    if (updatedContent != null && updatedContent != thongBao.noiDung) {
      try {
        ThongBao updatedThongBao = ThongBao(
          maTB: thongBao.maTB,
          noiDung: updatedContent,
          ngayTB: thongBao.ngayTB,
        );
        await _thongBaoController.updateThongBao(thongBao.maTB, updatedThongBao);
        _loadNotifications();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã cập nhật thông báo')),
        );
      } catch (e) {
        print('Error updating notification: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra khi cập nhật thông báo')),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(ThongBao thongBao) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa thông báo này không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Không'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Có'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  bool result = await _thongBaoController.xoaTB(thongBao.maTB);
                  if (result) {
                    _loadNotifications();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã xóa thông báo')),
                    );
                  }
                } catch (e) {
                  print('Error deleting notification: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Có lỗi xảy ra khi xóa thông báo')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      primary: Colors.blue,
      secondary: Colors.orange,
      surface: Colors.white,
      background: Colors.grey[100]!,
      error: Colors.red,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý thông báo'),
        backgroundColor: colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo nội dung',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _filterNotifications(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                        _filterNotifications();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNotifications.length,
              itemBuilder: (context, index) {
                final notification = _filteredNotifications[index];
                return GestureDetector(
                  onLongPress: () => _showDeleteConfirmationDialog(notification),
                  child: Card(
                    color: colorScheme.surface,
                    child: ListTile(
                      title: Text(utf8.decode (notification.noiDung.runes.toList())),
                      subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(notification.ngayTB)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.link),
                            onPressed: () => _openCustomerSelectionDialog(notification),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editNotification(notification),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotificationScreen()),
          ).then((_) => _loadNotifications());
        },
        child: Icon(Icons.add),
        backgroundColor: colorScheme.secondary,
      ),
    );
  }
}

