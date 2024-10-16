import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.only(left: 10.0, top: 20.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  backgroundColor: Color(0xFFF4F4F4),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  print('a');
                },
                icon: Icon(Icons.arrow_back_ios_new),
                label: const SizedBox.shrink(),
              ),
            ),
            Center(child: Text('Tạo tài khoản', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
            Container(
              height: 350,
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 28.0),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Tên',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Họ',
                      ),
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Mật khẩu',
                      ),
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nhập lại mật khẩu',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 342.0,
                        child: ElevatedButton(
                            onPressed: (){
                              print('a');
                            },
                            child: Text('Tạo tài khoản'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                            )
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
