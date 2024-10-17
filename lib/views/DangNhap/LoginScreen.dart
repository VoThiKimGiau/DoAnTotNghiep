import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/CompleteInformation.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/FogotPassword.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/RegisterScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/WelcomeScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/main.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thay Container thành Scaffold
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 100),
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          const Text(
            'Đăng nhập',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 24.0, top: 39.0, right: 24.0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tài khoản',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mật khẩu',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // Sử dụng Expanded để chiếm không gian còn lại
            child: Column(
              children: [
                SizedBox(
                  width: 342.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CompleteInformation()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Đăng nhập'),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()));
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 24.0),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Tạo tài khoản',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FogotPassword()));
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(left: 24.0),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Quên mật khẩu',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
