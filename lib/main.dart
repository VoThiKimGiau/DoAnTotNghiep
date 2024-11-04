import 'package:datn_cntt304_bandogiadung/views/TrangChu/TrangChu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/widgets/bottom_nav.dart';

import 'views/CaiDat/ProfileScreen.dart';
import 'views/ThongBao/DanhSachTB.dart';
import 'views/ThongBao/ThongBao.dart';
import 'views/DonHang/DonHang.dart';
import 'views/DangNhap/WelcomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
            backgroundColor: Colors.white,
            body: WelcomeScreen(),
          )
      ),
      debugShowCheckedModeBanner: false,
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
      TrangChuScreen(maKhachHang: widget.maKH,),
      NotificationScreen(maKhachHang: widget.maKH ),
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



