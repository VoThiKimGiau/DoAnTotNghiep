import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/RegeneratePassword.dart';
import 'package:flutter/material.dart';

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
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: const Color(0xFFF4F4F4),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => LoginScreen(controller: controller)),
                    // );
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                  label: const SizedBox.shrink(),
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