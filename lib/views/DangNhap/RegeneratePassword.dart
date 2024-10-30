import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:flutter/material.dart';

import '../../controllers/TaiKhoanController.dart';

class RegeneratePassword extends StatelessWidget {
  final TaiKhoanController controller = TaiKhoanController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 200.0),
            child: SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/send_mail.png'),
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              child: const Text(
                'Chúng tôi đã gửi email tạo lại mật khẩu cho bạn',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Trở về đăng nhập')),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
