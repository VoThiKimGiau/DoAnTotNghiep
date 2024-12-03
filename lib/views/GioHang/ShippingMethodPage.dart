import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';

class ShippingMethodPage extends StatefulWidget {
  final String selectedMethod;

  ShippingMethodPage({required this.selectedMethod});

  @override
  _ShippingMethodPageState createState() => _ShippingMethodPageState();
}

class _ShippingMethodPageState extends State<ShippingMethodPage> {
  String? selectedShipping;

  @override
  void initState() {
    super.initState();
    selectedShipping = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chọn phương thức vận chuyển'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, selectedShipping),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Thường'),
            value: 'Thường',
            groupValue: selectedShipping,
            onChanged: (value) {
              setState(() {
                selectedShipping = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Hỏa tốc'),
            value: 'Hỏa tốc',
            groupValue: selectedShipping,
            onChanged: (value) {
              setState(() {
                selectedShipping = value;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedShipping);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size(double.infinity, 40),
          ),
          child: const Text('Tiếp tục', style: TextStyle(color: Colors.white, fontSize: 16),),
        ),
      ),
    );
  }
}
