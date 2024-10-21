import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/address_screen.dart';

import 'order_success_screen.dart'; // Import AddressScreen

class PaymentScreen extends StatelessWidget {
  final double total;

  const PaymentScreen({
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin nhận hàng
            GestureDetector(
              onTap: () {
                // Chuyển đến trang chọn địa chỉ
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressScreen(), // Chuyển đến AddressScreen
                  ),
                );
              },
              child: _buildPaymentItem(
                title: 'Thẻ tín dụng/nhận hàng',
                content: 'Hoàng Minh | (+84) 3344556677\n140 Lê Trọng Tấn\nPhường Tây Thạnh,Quận Tân Phú\nTP.HCM',
              ),
            ),
            SizedBox(height: 16.0),

            // Phương thức thanh toán
            _buildPaymentItem(
              title: 'Phương thức thanh toán',
              content: 'Thanh toán sau nhận hàng',
            ),
            SizedBox(height: 16.0),

            // Phương thức vận chuyển
            _buildPaymentItem(
              title: 'Phương thức vận chuyển',
              content: 'Thường',
            ),
            SizedBox(height: 16.0),

            // Thông tin khuyến mãi
            _buildPaymentItem(
              title: 'Ưu đãi & Khuyến mãi',
              content: 'Miễn phí vận chuyển\nGiảm giá trên hóa đơn',
            ),
            SizedBox(height: 32.0),

            // Tổng kết đơn hàng
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tóm tính',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                _buildSummaryItem('Phí giao hàng', '\$8.00'),
                _buildSummaryItem('Tổng cộng', '\$${total.toStringAsFixed(2)}'), // Hiển thị tổng cộng
              ],
            ),

            // Nút Đặt hàng
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Logic xử lý đặt hàng
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderSuccessScreen(), // Chuyển đến OrderSuccessScreen
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Đặt hàng'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  // Hàm tạo widget hiển thị một mục thanh toán
  Widget _buildPaymentItem({
    required String title,
    required String content,
  }) {
    return GestureDetector(
      onTap: () {}, // Logic xử lý khi chạm vào
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),  
              ],
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  // Hàm tạo widget hiển thị một mục tổng kết
  Widget _buildSummaryItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}