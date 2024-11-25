import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({Key? key}) : super(key: key);

  @override
  _CustomerManagementScreenState createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final KhachHangController _khachHangController = KhachHangController();
  List<KhachHang> customers = [];
  List<KhachHang> filteredCustomers = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

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
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final loadedCustomers = await _khachHangController.fetchAllCustomer();
      setState(() {
        customers = loadedCustomers;
        filteredCustomers = loadedCustomers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Failed to load customers: $e');
    }
  }

  void _filterCustomers(String query) {
    setState(() {
      filteredCustomers = customers
          .where((customer) => customer.sdt.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _toggleCustomerStatus(KhachHang customer) async {
    try {
      customer.hoatDong = !customer.hoatDong;
      await _khachHangController.updateCustomer(customer.maKH, customer);
      setState(() {});
    } catch (e) {
      _showErrorDialog('Failed to update customer status: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(KhachHang customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('ID', customer.maKH),
              _detailRow('Name', customer.tenKH),
              _detailRow('Phone', customer.sdt),
              _detailRow('Email', customer.email),
              _detailRow('Gender', customer.gioiTinh == true ? 'Nam' : 'Nữ'),
              _detailRow('Birthday', customer.ngaySinh?.toString() ?? 'N/A'),
              _detailRow('Username', customer.tenTK),
              _detailRow('Status', customer.hoatDong ? 'Hoạt động' : 'Khoá'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý khách hàng'),
        backgroundColor: colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm theo số điện thoại',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterCustomers,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadCustomers,
              child: ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(customer.tenKH),
                      subtitle: Text(customer.sdt),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: customer.hoatDong,
                            onChanged: (value) => _toggleCustomerStatus(customer),
                            activeColor: colorScheme.secondary,
                          ),
                          IconButton(
                            icon: Icon(Icons.info_outline),
                            onPressed: () => _showCustomerDetails(customer),
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadCustomers,
        child: Icon(Icons.refresh),
        backgroundColor: colorScheme.secondary,
      ),
    );
  }
}

