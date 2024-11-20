import 'package:flutter/material.dart';

import '../../colors/color.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Chọn phương thức thanh toán'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, selectedPayment),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: Text('Thanh toán khi nhận hàng'),
            value: 'Thanh toán khi nhận hàng',
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
            // Trả về phương thức thanh toán đã chọn cho CheckoutPage
            Navigator.pop(context, selectedPayment);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size(double.infinity, 50),
          ),
          child: const Text('Tiếp tục', style: TextStyle(color: Colors.white, fontSize: 16),),
        ),
      ),
    );
  }
}
