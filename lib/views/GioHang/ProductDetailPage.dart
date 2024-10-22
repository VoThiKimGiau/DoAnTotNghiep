import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/GioHangPage.dart';

class ProductDetailPage extends StatelessWidget {
  final String color;
  final String size;
  final double price;

  ProductDetailPage({required this.color, required this.size, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sản phẩm 1", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("\$${price.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, color: Colors.blue)),
            SizedBox(height: 10),
            Text("Màu sắc: $color", style: TextStyle(fontSize: 18)),
            Text("Kích cỡ: $size", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Mô tả: Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection...", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            // Placeholder for product images
            Expanded(child: Placeholder(fallbackHeight: 200)),
            SizedBox(height: 20),
            // Nút để quay về trang chọn sản phẩm
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Quay về trang trước
              },
              child: Text("Quay lại"),
            ),
            // Nút để chuyển đến trang giỏ hàng

          ],
        ),
      ),
    );
  }
}
