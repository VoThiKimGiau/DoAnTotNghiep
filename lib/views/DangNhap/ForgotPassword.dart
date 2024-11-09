import 'dart:math';

import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/RegeneratePassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../controllers/TaiKhoanController.dart';
import '../../models/KhachHang.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // subaccount
  // SECRET KEY: e5c3b1db764cc245265b6febd7d4f11f
  // API KEY: 6ca9bb3e1f0c3fc799469ff70eae960f

  // Primary
  // SECRET KEY: d61394946a34fc8ebc0c1837c9775cc2
  // API KEY: 02a3731bdbd0816cc5bffdeeb9740d71

  final TextEditingController emailController = TextEditingController();
  KhachHangController khachHangController = KhachHangController();

  final String apiKeyPublic = '02a3731bdbd0816cc5bffdeeb9740d71';
  final String apiKeyPrivate = 'd61394946a34fc8ebc0c1837c9775cc2';
  final String fromEmail = 'cuahanggiadunghuit@gmail.com';
  final String fromName = 'Cửa hàng gia dụng HUIT';
  final int templateID = 6448442;

  final Map<String, String> variables = {
    "MKMoi": "",
    "TenDN": "",
    "TenKH": "",
    "GioiTinh": "",
  };
  final String subject = 'Mã code để đặt lại mật khẩu';
  late String newCode;

  @override
  void initState() {
    super.initState();
  }

  String generateRandomString(int length) {
    const characters =
        'abcdefghjkmnopqrstuvwxyzABCDEFGHJKMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(left: 27, top: 63, bottom: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.white,
                    ),
                    child: SvgPicture.asset('assets/icons/arrowleft.svg'),
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                width: 300,
                child: Image.asset('assets/images/logo.png'),
              ),
              const Text(
                'Quên mật khẩu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    newCode = generateRandomString(8);
                    if (email.isNotEmpty) {
                      KhachHang? customer =
                          await khachHangController.getCustomerByEmail(email);

                      if (customer != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegeneratePassword(
                                maKH: customer.maKH,
                                code: newCode,
                              )),
                        );

                        khachHangController.sendEmail(
                          apiKeyPublic: apiKeyPublic,
                          apiKeyPrivate: apiKeyPrivate,
                          fromEmail: fromEmail,
                          fromName: fromName,
                          toEmail: email,
                          toName: customer.tenKH ?? 'Khách hàng',
                          templateID: templateID,
                          variables: {
                            "MKMoi": newCode,
                            "TenDN": customer.tenTK ?? 'username',
                            "TenKH": customer.tenKH ?? 'Tên Khách Hàng',
                            "GioiTinh":
                                customer.gioiTinh == false ? "ông" : "bà",
                          },
                          subject: subject,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Email này chưa đăng ký tài khoản nào. Vui lòng kiểm tra lại')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập email')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Tiếp tục'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
