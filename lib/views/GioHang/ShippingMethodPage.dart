import 'package:flutter/material.dart';
import 'PromoCodePage.dart';

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
      appBar: AppBar(
        title: Text('Chọn phương thức vận chuyển'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, selectedShipping),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: Text('Thường'),
            value: 'Thường',
            groupValue: selectedShipping,
            onChanged: (value) {
              setState(() {
                selectedShipping = value;
              });
            },
          ),
          RadioListTile<String>(
            title: Text('Hỏa tốc'),
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
          onPressed: () async {
            // Chuyển qua trang PromoCodePage và nhận mã khuyến mãi đã chọn
            final selectedPromoCode = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) => PromoCodePage(
                  selectedPromoCode: '', // Giá trị ban đầu của mã khuyến mãi
                  promoCodes: ['Giảm tối đa \$30', 'Giảm 9%', 'Giảm tối đa \$70'], // Danh sách mã khuyến mãi
                ),
              ),
            );

            // Nếu người dùng chọn mã khuyến mãi, xử lý mã được chọn tại đây
            if (selectedPromoCode != null) {
              print('Mã khuyến mãi đã chọn: $selectedPromoCode');
              // Bạn có thể xử lý tiếp hoặc lưu mã này lại tùy vào logic của bạn
            }
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
