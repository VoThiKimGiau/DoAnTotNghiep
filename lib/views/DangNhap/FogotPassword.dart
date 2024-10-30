import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/RegeneratePassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/TaiKhoanController.dart';

class FogotPassword extends StatelessWidget{
  final TaiKhoanController controller = TaiKhoanController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
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
              const Text('Quên mật khẩu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
              ),
              Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 342.0,
                          child: ElevatedButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegeneratePassword())
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Tiếp tục')
                          ),
                        )
                      ],
                    ),
                  )
            ],
          ),
        )
    );
  }

}