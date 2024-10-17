
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/widgets/bottom_nav.dart';

import 'CaiDat/ProfileScreen.dart';
import 'ThongBao/DanhSachTB.dart';
import 'ThongBao/ThongBao.dart';
import 'DonHang/DonHang.dart';
import 'DangNhap/WelcomeScreen.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Comfortaa',
      ),
      home: SafeArea(
          child: Scaffold(
            body: WelcomeScreen(),
          )
      ),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Screen'),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    NotificationScreen(maKhachHang: "KH1"),
    OrderListScreen(maKH:"KH1"),
    ProfileScreen(makh: "KH1",)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}



