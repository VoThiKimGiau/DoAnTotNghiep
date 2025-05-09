import 'package:flutter/material.dart';


class NotificationScreenEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/bell.png'),
            SizedBox(height: 16),
            Text(
              'Tạm thời không có thông báo',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                  fontFamily: 'Comfortaa'
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the home page or perform any action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Trở về trang chủ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Comfortaa'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

