import 'package:flutter/material.dart';
// import 'package:square_in_app_payments/in_app_payments.dart';
// import 'package:square_in_app_payments/models.dart';
import '../../colors/color.dart';
import '../../controllers/CheckoutController.dart';

class PaymentMethodPage extends StatefulWidget {
  final String selectedMethod;

  PaymentMethodPage({required this.selectedMethod});

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final CheckoutController checkoutController = CheckoutController();
  String? selectedPayment;

  @override
  void initState() {
    super.initState();
    selectedPayment = widget.selectedMethod;
  }

  // void _startCardEntryFlow() async {
  //   try {
  //     await InAppPayments.startCardEntryFlow(
  //       onCardNonceRequestSuccess: (CardDetails cardDetails) {
  //         String nonce = cardDetails.nonce;
  //         _processPayment(nonce);
  //       },
  //       onCardEntryCancel: () {
  //         print("Người dùng đã hủy nhập liệu thẻ.");
  //       },
  //     );
  //   } catch (e) {
  //     print("Lỗi: $e");
  //   }
  // }
  //
  // void _processPayment(String nonce) async {
  //   try {
  //     // Assuming amount is fixed for demonstration; you can modify as needed
  //     await checkoutController.createPayment('1000', 'USD', nonce);
  //     // Show success message or navigate
  //   } catch (e) {
  //     // Show an error message (e.g., SnackBar)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Payment failed: $e")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chọn phương thức thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, selectedPayment),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Thanh toán khi nhận hàng'),
            value: 'Thanh toán khi nhận hàng',
            groupValue: selectedPayment,
            onChanged: (value) {
              setState(() {
                selectedPayment = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Thanh toán online'),
            value: 'Thanh toán online',
            groupValue: selectedPayment,
            onChanged: (value) {
              setState(() {
                selectedPayment = value;
              });
            },
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     if (selectedPayment == 'Thanh toán online') {
          //       //_startCardEntryFlow();
          //     } else {
          //       print("Chọn phương thức thanh toán khi nhận hàng.");
          //     }
          //   },
          //   child: Text('Pay'),
          // ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedPayment);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size(double.infinity, 50),
          ),
          child: const Text(
            'Tiếp tục',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}