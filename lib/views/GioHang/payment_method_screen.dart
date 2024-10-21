import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/order_success_screen.dart'; // Import OrderSuccessScreen

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // Biến trạng thái cho phương thức thanh toán được chọn
  String selectedPaymentMethod = 'Thanh toán sau nhận hàng';

  // Hàm xử lý khi chọn một phương thức thanh toán
  void _onPaymentMethodSelected(String paymentMethod) {
    setState(() {
      selectedPaymentMethod = paymentMethod;
    });
  }

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
        title: Text('Chọn phương thức thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Danh sách phương thức thanh toán
            Expanded(
              child: ListView(
                children: [
                  _buildPaymentMethodItem(
                    paymentMethod: 'Thanh toán sau nhận hàng',
                    isSelected: true,
                  ),
                  SizedBox(height: 8.0),
                  _buildPaymentMethodItem(
                    paymentMethod: 'Thanh toán online',
                  ),
                ],
              ),
            ),

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
                _buildSummaryItem('Tổng cộng', '\$208.00'), // Hiển thị tổng cộng
              ],
            ),

            // Nút Tiếp tục
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
              child: Text('Tiếp tục'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  // Hàm tạo widget hiển thị một mục phương thức thanh toán
  Widget _buildPaymentMethodItem({
    required String paymentMethod,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        _onPaymentMethodSelected(paymentMethod);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              paymentMethod,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            if (isSelected)
              Icon(Icons.check),
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