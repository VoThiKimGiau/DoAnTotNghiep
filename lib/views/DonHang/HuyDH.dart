import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class HuyDHScreen extends StatefulWidget {
  final String maKH;

  HuyDHScreen({required this.maKH});

  @override
  _HuyDHScreen createState() => _HuyDHScreen();
}

class _HuyDHScreen extends State<HuyDHScreen> {
  @override
  void initState() {
    super.initState();
    // Sử dụng addPostFrameCallback để gọi _showBottomSheet sau khi widget đã được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context, widget.maKH);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Center(
          child: Image.asset('assets/images/huydon.png'),
        ),
      ),
    );
  }
}

void _showBottomSheet(BuildContext context, String maKH) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double bottomSheetHeight = screenHeight / 3; // 1/3 chiều cao màn hình

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: bottomSheetHeight,
        padding: const EdgeInsets.only(top: 40, left: 29, right: 29),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Đơn hàng đã được hủy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gabarito',
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            const Center(
              child: Text(
                'Bạn có thể xem lại các đơn hàng đã hủy trong đơn hàng',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(maKH: maKH,)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Quay về trang chủ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
