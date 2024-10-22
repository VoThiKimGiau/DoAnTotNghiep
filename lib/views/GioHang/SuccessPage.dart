import 'package:flutter/material.dart';

import '../../services/storage/storage_service.dart';


class SuccessPage extends StatelessWidget {
  final StorageService storageService = StorageService(); // Khởi tạo đối tượng StorageService

  @override
  Widget build(BuildContext context) {
    // Gọi getImageUrl để lấy URL của hình ảnh
    String imageUrl = storageService.getImageUrl('success_image'); // Thay 'success_image' bằng tên hình ảnh của bạn

    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt hàng thành công'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                imageUrl, // Hiển thị hình ảnh từ URL
                height: 200, // Đặt chiều cao cho hình ảnh
                width: 200, // Đặt chiều rộng cho hình ảnh
                fit: BoxFit.cover, // Căn chỉnh hình ảnh
              ),
              SizedBox(height: 20),
              Text(
                'Bạn đã đặt hàng thành công!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Chúng tôi sẽ gửi email xác nhận cho bạn.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Trở lại trang trước đó
                },
                child: Text('Xem chi tiết đơn hàng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
