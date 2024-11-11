import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class TBTraHangScreen extends StatefulWidget {
  final String maKH;

  TBTraHangScreen({required this.maKH});

  @override
  _TBTraHangScreen createState() => _TBTraHangScreen();
}

class _TBTraHangScreen extends State<TBTraHangScreen> {
  @override
  void initState() {
    super.initState();
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
          child: Image.asset('assets/images/hoantra.png'),
        ),
      ),
    );
  }
}

void _showBottomSheet(BuildContext context, String maKH) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Yêu cầu trả hàng đã được gửi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Vui lòng theo dõi trạng thái trả hàng ở đơn hàng',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MainScreen(maKH: maKH),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Quay về trang chủ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}