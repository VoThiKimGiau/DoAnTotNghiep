import 'package:flutter/material.dart';

class OrderEmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/order.png'),
            const SizedBox(height: 16),
            const Text(
              'Tạm thời không có đơn hàng',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Comfortaa'
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the home page or perform any action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Trở về trang chủ',
                style: TextStyle(
                    fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

