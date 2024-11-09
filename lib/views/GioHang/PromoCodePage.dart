import 'package:datn_cntt304_bandogiadung/models/Promotion.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/Widgets/promotion_item.dart';
import 'package:flutter/material.dart';

class PromoCodePage extends StatefulWidget {
  final String selectedPromoCode;
  final List<Promotion> promotions;

  const PromoCodePage(
      {super.key, required this.selectedPromoCode, required this.promotions});

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
        title: const Text('Chọn mã khuyến mãi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pop(context, selectedCode), // Trả về mã đã chọn
        ),
      ),
      body: Column(
        children: widget.promotions.map((code) {
          // return RadioListTile<String>(
          //   title: Text(code.moTa),
          //   value: code.moTa,
          //   groupValue: selectedCode,
          //   onChanged: (value) {
          //     setState(() {
          //       selectedCode = value;
          //     });
          //   },
          // );
          return InkWell(
            onTap: () {
              selectedCode = code.moTa;
              setState(() {});
            },
            child: PromotionItem(
              promotion: code,
              isSelect: selectedCode == code.moTa,
            ),
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
