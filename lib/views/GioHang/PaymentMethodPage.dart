import 'package:flutter/material.dart';
import 'ShippingMethodPage.dart'; // Import trang chọn phương thức vận chuyển

class PaymentMethodPage extends StatefulWidget {
  final String selectedMethod;

  PaymentMethodPage({required this.selectedMethod});

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String? selectedPayment;

  @override
  void initState() {
    super.initState();
    selectedPayment = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn phương thức thanh toán'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, selectedPayment),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: Text('Thanh toán sau khi nhận hàng'),
            value: 'Thanh toán sau khi nhận hàng',
            groupValue: selectedPayment,
            onChanged: (value) {
              setState(() {
                selectedPayment = value;
              });
            },
          ),
          RadioListTile<String>(
            title: Text('Thanh toán online'),
            value: 'Thanh toán online',
            groupValue: selectedPayment,
            onChanged: (value) {
              setState(() {
                selectedPayment = value;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Điều hướng sang trang phương thức vận chuyển sau khi bấm "Tiếp tục"
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShippingMethodPage(
                  selectedMethod: 'Thường', // Phương thức vận chuyển mặc định
                ),
              ),
            );
          },
          child: Text('Tiếp tục'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
