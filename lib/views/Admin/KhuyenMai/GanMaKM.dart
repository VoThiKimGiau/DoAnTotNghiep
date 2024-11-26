import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/models/KhuyenMai.dart';
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';
import 'package:datn_cntt304_bandogiadung/models/KMKH.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KMKHController.dart';

class AssignPromotionDialog extends StatefulWidget {
  final KhuyenMai promotion;

  AssignPromotionDialog({Key? key, required this.promotion}) : super(key: key);

  @override
  _AssignPromotionDialogState createState() => _AssignPromotionDialogState();
}

class _AssignPromotionDialogState extends State<AssignPromotionDialog> {
  final KhachHangController _khachHangController = KhachHangController();
  final KMKHController _kmkhController = KMKHController();
  List<KhachHang> _customers = [];
  List<KhachHang> _selectedCustomers = [];
  Map<String, int> _customerPromotionCount = {};
  bool _isLoading = true;
  String _searchQuery = '';
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await _khachHangController.fetchAllCustomer();
      List<KMKH> promotions = await _kmkhController.getAll();

      Map<String, int> promotionCount = {};
      for (var kmkh in promotions) {
        if (kmkh.khuyenMai == widget.promotion.maKM) {
          promotionCount[kmkh.khachHang ?? ''] =
              (promotionCount[kmkh.khachHang] ?? 0) + (kmkh.soluong ?? 0);
        }
      }

      setState(() {
        _customers = customers;
        _customerPromotionCount = promotionCount;
        _isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi tải khách hàng: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleCustomerSelection(KhachHang customer) {
    setState(() {
      if (_selectedCustomers.contains(customer)) {
        _selectedCustomers.remove(customer);
      } else {
        _selectedCustomers.add(customer);
      }
      _updateSelectAllState();
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectAll) {
        _selectedCustomers.clear();
      } else {
        _selectedCustomers = List.from(_customers);
      }
      _selectAll = !_selectAll;
    });
  }

  void _updateSelectAllState() {
    _selectAll = _selectedCustomers.length == _customers.length;
  }

  void _assignPromotionToCustomers() async {
    if (_selectedCustomers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn ít nhất một khách hàng')),
      );
      return;
    }

    if (_selectedCustomers.length > widget.promotion.slkhNhan) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số lượng khuyến mãi không đủ cho tất cả khách hàng đã chọn')),
      );
      return;
    }

    try {
      for (var customer in _selectedCustomers) {
        await _kmkhController.addCustomerPromotion(KMKH(
          khachHang: customer.maKH,
          khuyenMai: widget.promotion.maKM,
          soluong: 1,
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Khuyến mãi đã được gán thành công')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gán khuyến mãi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Gán Khuyến Mãi Cho Khách Hàng'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm Khách Hàng',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chọn Tất Cả'),
                Switch(
                  value: _selectAll,
                  onChanged: (bool value) {
                    _toggleSelectAll();
                  },
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _customers.length,
                itemBuilder: (context, index) {
                  final customer = _customers[index];
                  if (_searchQuery.isNotEmpty &&
                      !customer.tenKH.toLowerCase().contains(_searchQuery) &&
                      !customer.sdt.contains(_searchQuery)) {
                    return SizedBox.shrink();
                  }
                  return CheckboxListTile(
                    title: Text(customer.tenKH),
                    subtitle: Text(
                        '${customer.sdt} - Đã sở hữu: ${_customerPromotionCount[customer.maKH] ?? 0}'),
                    value: _selectedCustomers.contains(customer),
                    onChanged: (bool? value) {
                      _toggleCustomerSelection(customer);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Hủy'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Gán Khuyến Mãi'),
          onPressed: _assignPromotionToCustomers,
        ),
      ],
    );
  }
}
