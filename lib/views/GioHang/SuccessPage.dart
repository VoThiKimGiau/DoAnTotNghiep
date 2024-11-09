import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';

import '../../services/storage/storage_service.dart';

class SuccessPage extends StatelessWidget {
  final StorageService storageService = StorageService();

  SuccessPage({super.key}); // Khởi tạo đối tượng StorageService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/icons/thanhtoan.png', // Hiển thị hình ảnh từ URL
                height: 100, // Đặt chiều cao cho hình ảnh
                width: 250, // Đặt chiều rộng cho hình ảnh
                fit: BoxFit.contain, // Căn chỉnh hình ảnh
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 29, vertical: 40),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Bạn đã đặt hàng thành công!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Chúng tôi sẽ gửi email xác nhận cho bạn.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 65,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                          AppColors.primaryColor,
                        )),
                        onPressed: () {
                          Navigator.of(context).pop(); // Trở lại trang trước đó
                        },
                        child: const Text(
                          'Xem chi tiết đơn hàng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
