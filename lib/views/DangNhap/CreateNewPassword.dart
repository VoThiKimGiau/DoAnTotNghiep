import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:flutter/material.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String? maKH;

  CreateNewPasswordScreen({required this.maKH});

  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController matKhauController = TextEditingController();
  final TextEditingController nhapLaiMatKhauController =
      TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  KhachHangController khachHangController = KhachHangController();
  KhachHang? khachHang;

  @override
  void initState() {
    super.initState();
    fetchCustomer();
  }

  Future<void> fetchCustomer() async {
    try {
      KhachHang? fetchItem = await khachHangController.getKhachHang(widget.maKH);
      setState(() {
        khachHang = fetchItem;
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        khachHang = null;
      });
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
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                height: 300,
                width: 300,
                child: Image.asset('assets/images/logo.png'),
              ),
              const Text(
                'Tạo lại mật khẩu',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 23.0),
                child: TextField(
                  controller: matKhauController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Mật khẩu',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !showPassword,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 23),
                child: TextField(
                  controller: nhapLaiMatKhauController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Nhập lại mật khẩu',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !showConfirmPassword,
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async{
                    String matKhau = matKhauController.text.trim();
                    String nhapLaiMatKhau =
                        nhapLaiMatKhauController.text.trim();

                    if (matKhau.length < 8 || matKhau.length > 30) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Mật khẩu phải có ít nhất 8 ký tự và nhiều nhất 30 ký tự!'),
                        ),
                      );
                      return;
                    }

                    if (matKhau == nhapLaiMatKhau) {
                      khachHang!.matKhau = matKhauController.text.trim();
                      if(await khachHangController.updateCustomer(widget.maKH, khachHang!)){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Mật khẩu đã được thay đổi thành công!'),
                            duration: Duration(seconds: 1),),
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      });
                    } }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Mật khẩu không khớp! Vui lòng kiểm tra lại')),
                      );
                    }
                  },
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
