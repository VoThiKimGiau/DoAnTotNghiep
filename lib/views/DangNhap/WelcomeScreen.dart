import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';

import '../../controllers/TaiKhoanController.dart';
import 'LoginScreen.dart';


class WelcomeScreen extends StatelessWidget {
  final TaiKhoanController controller = TaiKhoanController();


  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 25.0),
                  child: const Text(
                    'CỬA HÀNG GIA DỤNG HUIT',
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  'XIN CHÀO QUÝ KHÁCH',
                  style: TextStyle(
                    fontSize: 25,
                    color: AppColors.primaryColor,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
