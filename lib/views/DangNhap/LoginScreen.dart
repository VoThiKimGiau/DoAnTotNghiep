import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhanVienController.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/CompleteInformation.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/ForgotPassword.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/RegisterScreen.dart';
import 'package:datn_cntt304_bandogiadung/main.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/DanhSachPhieuNhap.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/TrangChuQuanLy.dart';
import '../../models/KhachHang.dart';
import '../../models/NhanVien.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController tenTKController =
      TextEditingController(text: 'vaten');
  final TextEditingController matKhauController =
      TextEditingController(text: '123');
  late Future<KhachHang?> login;
  late KhachHang? khachHang;
  late KhachHangController controller;
  bool isCustomer = true;
  bool isEmployee = false;
  late NhanVienController nhanVienController;
  late NhanVien? nhanVien;
  String? maNV="";

  @override
  void initState() {
    super.initState();

    controller = KhachHangController();
    nhanVienController = NhanVienController();
  }

  Future<void> _login() async {
    if (tenTKController.text.isEmpty || matKhauController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }
    if (isCustomer) {
      try {
        khachHang = await controller.login(
            tenTKController.text, matKhauController.text);
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
    } else {
      maNV = await nhanVienController.dangNhapNV(
          tenTKController.text, matKhauController.text);
      if (maNV == null) {
        SnackBar(content: Text('Login failed. Please check your credentials.'));
      } else {

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ShopDashboard(maNV: maNV?? ' ')));
      }
    }
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isCustomer,
                    onChanged: (bool? value) {
                      setState(() {
                        isCustomer = value!;
                        isEmployee = !value; // Không thể chọn cả hai
                      });
                    },
                  ),
                  const Text('Khách hàng'),
                  Checkbox(
                    value: isEmployee,
                    onChanged: (bool? value) {
                      setState(() {
                        isEmployee = value!;
                        isCustomer = !value; // Không thể chọn cả hai
                      });
                    },
                  ),
                  const Text('Nhân viên'),
                ],
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
                                builder: (context) => ForgotPassword(),
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
