import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final String maDH;
  OrderDetailScreen({required this.maDH});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng #$maDH'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order status
            _buildOrderStatus(),
            SizedBox(height: 16.0),
            Text(
              'Chi tiết đơn hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            _buildProductDetails(),
            SizedBox(height: 16.0),
            _buildAddressDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusItem('Đã giao hàng', true),
        _buildStatusItem('Đang giao hàng', false, date: '30.10.2024'),
        _buildStatusItem('Đã xác nhận', false, date: '28.10.2024'),
        _buildStatusItem('Đang xử lý', false, date: '28.10.2024'),
      ],
    );
  }

  Widget _buildStatusItem(String title, bool isChecked, {String? date}) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {},
          shape: CircleBorder(),
        ),
        Expanded(
          child: Text(title),
        ),
        if (date != null) Text(date),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.shopping_cart, color: Colors.black54),
          Text('4 sản phẩm', style: TextStyle(fontSize: 16)),
          TextButton(
            onPressed: () {
              // Navigate to product details
            },
            child: Text('Xem tất cả'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressDetails() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Địa chỉ:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Text(
            '2715 Ash Dr. San Jose, South Dakota 83475\n121-224-7890',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          TextButton(
            onPressed: () {
              // Edit address action
            },
            child: Text('Sửa', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}


