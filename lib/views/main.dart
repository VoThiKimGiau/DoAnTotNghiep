
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/widgets/bottom_nav.dart';

import 'CaiDat/ProfileScreen.dart';
import 'ThongBao/DanhSachTB.dart';
import 'ThongBao/ThongBao.dart';
import 'DonHang/DonHang.dart';
import 'DangNhap/WelcomeScreen.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Screen'),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String? maKH;
  const MainScreen({required this.maKH, Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    // Initialize _widgetOptions in initState where widget.maKH is accessible
    _widgetOptions = <Widget>[
      HomeScreen(),
      NotificationScreenEmpty(),
      OrderListScreen(maKH: widget.maKH ),
      ProfileScreen(makh: widget.maKH ),
    ];
  }
  int _selectedIndex = 0;


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



