import 'package:flutter/material.dart';

class PromoCodePage extends StatefulWidget {
  final String selectedPromoCode;
  final List<String> promoCodes;

  PromoCodePage({required this.selectedPromoCode, required this.promoCodes});

  @override
  _PromoCodePageState createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
  String? selectedCode;

  @override
  void initState() {
    super.initState();
    selectedCode = widget.selectedPromoCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn mã khuyến mãi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, selectedCode), // Trả về mã đã chọn
        ),
      ),
      body: Column(
        children: widget.promoCodes.map((code) {
          return RadioListTile<String>(
            title: Text(code),
            value: code,
            groupValue: selectedCode,
            onChanged: (value) {
              setState(() {
                selectedCode = value;
              });
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedCode); // Trả về mã đã chọn
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
