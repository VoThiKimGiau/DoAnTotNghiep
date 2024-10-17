import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';

class TrangChu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    child: ElevatedButton.icon(
                        onPressed: (){
                          print('a');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        label: const Text('Hoàn thành')
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }

}