import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';

class CustomerSelectionDialog extends StatefulWidget {
  final List<KhachHang> customers;

  CustomerSelectionDialog({Key? key, required this.customers}) : super(key: key);

  @override
  _CustomerSelectionDialogState createState() => _CustomerSelectionDialogState();
}

class _CustomerSelectionDialogState extends State<CustomerSelectionDialog> {
  List<KhachHang> _selectedCustomers = [];
  List<KhachHang> _filteredCustomers = [];
  bool _selectAll = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCustomers = widget.customers;
  }

  void _filterCustomers(String query) {
    setState(() {
      _filteredCustomers = widget.customers.where((customer) {
        return customer.tenKH.toLowerCase().contains(query.toLowerCase()) ||
            customer.sdt.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Chọn khách hàng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên hoặc số điện thoại',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCustomers,
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Chọn tất cả'),
              value: _selectAll,
              onChanged: (bool? value) {
                setState(() {
                  _selectAll = value ?? false;
                  if (_selectAll) {
                    _selectedCustomers = List.from(_filteredCustomers);
                  } else {
                    _selectedCustomers.clear();
                  }
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = _filteredCustomers[index];
                  return CheckboxListTile(
                    title: Text(customer.tenKH),
                    subtitle: Text('${customer.sdt} - ${customer.email}'),
                    value: _selectedCustomers.contains(customer),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value ?? false) {
                          _selectedCustomers.add(customer);
                        } else {
                          _selectedCustomers.remove(customer);
                        }
                        _selectAll = _selectedCustomers.length == _filteredCustomers.length;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Hủy'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  child: Text('Xác nhận'),
                  onPressed: () => Navigator.of(context).pop(_selectedCustomers),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

