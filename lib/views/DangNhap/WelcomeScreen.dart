import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';

import 'LoginScreen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: Image.asset('assets/images/logo.png'),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 25.0),
            child: const Text(
              'CỬA HÀNG GIA DỤNG HUIT',
              style: TextStyle(
                fontSize: 25,
                color: AppColors.primaryColor,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const Text(
            'XIN CHÀO QUÝ KHÁCH',
            style: TextStyle(
              fontSize: 25,
              color: AppColors.primaryColor,
              decoration: TextDecoration.none,
            ),
          )
        ],
      ),
    );
  }
}
