import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../controllers/DonHangController.dart';
import '../../models/DonHang.dart';


class TodaysOrdersScreen extends StatefulWidget {
  @override
  _TodaysOrdersScreenState createState() => _TodaysOrdersScreenState();
}

class _TodaysOrdersScreenState extends State<TodaysOrdersScreen> {
  final DonHangController _donHangController = DonHangController();
  List<DonHang> _orders = [];
  List<DonHang> _filteredOrders = [];
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'all';
  final DonHangController donHangController = DonHangController();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }


  void _updateOrderStatus(String madh,String trangThai) async {
    bool success = await donHangController.updateOrderStatus(madh, trangThai);
    if (success) {
      print('Order status updated successfully');
      // Cập nhật giao diện nếu cần
    } else {
      print('Failed to update order status');
    }
  }
  Future<void> _fetchOrders() async {
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final String startDate = formatter.format(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day));
    final String endDate = formatter.format(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59));

    try {
      final fetchedOrders = await _donHangController.fetchDonHangByDateRange(startDate, endDate);
      setState(() {
        _orders = fetchedOrders;
        _filterOrders();
      });
    } catch (error) {
      print('Failed to fetch orders: $error');
      // You might want to show an error message to the user here
    }
  }

  void _filterOrders() {
    if (_selectedStatus == 'all') {
      _filteredOrders = _orders;
    } else {
      _filteredOrders = _orders.where((order) => order.trangThaiDH == _selectedStatus).toList();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchOrders();
    }
  }

  void _handleStatusChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedStatus = newValue;
        _filterOrders();
      });
    }
  }

  Future<void> _handleConfirmOrder(String maDH) async {
    // Implement the logic to confirm the order
    // This could involve calling an API to update the order status
    print('Confirming order: $maDH');
    // After confirming, refetch the orders to update the list
    await _fetchOrders();
    _updateOrderStatus(maDH, "Đã xử lý");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\'s Đơn hàng'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                ),
                DropdownButton<String>(
                  value: _selectedStatus,
                  onChanged: _handleStatusChange,
                  items: <String>['all', 'Đang xử lý', 'Đã giao hàng', 'Đã huỷ']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == 'all' ? 'All Statuses' : value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return Card(
                  child: ListTile(
                    title: Text('Order ID: ${order.maDH}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer: ${order.khachHang}'),
                        Text('Status: ${order.trangThaiDH}'),
                        Text('Total: ${order.thanhTien.toStringAsFixed(2)} VND'),
                      ],
                    ),
                    trailing: order.trangThaiDH == 'Đang xử lý'
                        ? ElevatedButton(
                      onPressed: () => _handleConfirmOrder(order.maDH),
                      child: Text('Confirm'),
                    )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}