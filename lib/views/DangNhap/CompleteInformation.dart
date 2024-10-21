import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/main.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:flutter/material.dart';

import '../../controllers/KhachHangController.dart';
import '../../models/KhachHang.dart';

class CompleteInformation extends StatefulWidget {
  @override
  _CompleteInformationState createState() => _CompleteInformationState();
}

class _CompleteInformationState extends State<CompleteInformation> {
  int _age = 18; // Giá trị mặc định cho độ tuổi
  int _selectedAge = 18;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            margin: const EdgeInsets.only(top: 161.0),
            child: Column(
              children: [
              const Align(
              alignment: Alignment.center,
              child: Text(
                'Thông tin về bạn',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0, left: 20.0),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bạn là?',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('Nam');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(161, 50),
                    ),
                    child: const Text('Nam'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      print('Nữ');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryColor,
                      minimumSize: const Size(161, 50),
                    ),
                    child: const Text('Nữ'),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0, left: 20.0),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bạn bao nhiêu tuổi?',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Text('Độ tuổi')
                    ),
                    Container(
                      width: 250,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButton<int>(
                        value: _selectedAge,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedAge = newValue!;
                          });
                        },
                        isExpanded: true,
                        items: List.generate(83, (index) => index + 18).map((
                            age) {
                          return DropdownMenuItem<int>(
                            value: age,
                            child: Text(age.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 342.0,
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Hoàn thành')
                        ),
                      )
                    ],
                  ),
            )
        ],
      ),
    ),)
    ,
    );
  }
}