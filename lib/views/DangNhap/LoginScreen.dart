import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/TaiKhoanController.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/CompleteInformation.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/FogotPassword.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/RegisterScreen.dart';
import 'package:datn_cntt304_bandogiadung/models/TaiKhoan.dart';
import 'package:datn_cntt304_bandogiadung/main.dart';
import 'package:flutter/material.dart';

import '../../models/KhachHang.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController tenTKController = TextEditingController();
  final TextEditingController matKhauController = TextEditingController();
  late Future<KhachHang?> login;
  late KhachHang? khachHang;
  late KhachHangController controller;

  @override
  void initState() {
    super.initState();
    controller= KhachHangController();
  }

  Future<void> _login() async {
    if (tenTKController.text.isEmpty || matKhauController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    try {
      khachHang = await controller
          .login(tenTKController.text, matKhauController.text);
      if (khachHang == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login failed. Please check your credentials.')),
        );
      } else {
        String? maKH = khachHang?.maKH;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScreen(maKH: maKH)));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  // void _login() async {
  //   String tenTK = tenTKController.text;
  //   String matKhau = matKhauController.text;
  //
  //
  //   try {
  //     List<TaiKhoan> taiKhoans =
  //         await widget.controller.fetchTK(tenTK, matKhau);
  //     // Xử lý kết quả, ví dụ: điều hướng đến trang chính
  //     if (taiKhoans.isNotEmpty) {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //     }
  //   } catch (e) {
  //     // Xử lý lỗi
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
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
                margin:
                const EdgeInsets.only(left: 24.0, top: 39.0, right: 24.0),
                child: Column(
                  children: [
                    TextField(
                      controller: tenTKController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Tài khoản',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: TextField(
                        controller: matKhauController,
                        obscureText: true, // Hide password text
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Mật khẩu',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 342.0,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Đăng nhập'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
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
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FogotPassword(),
                              ),
                            );
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
        ),
      ),
    );
  }
}
