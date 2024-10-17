import 'package:datn_cntt304_bandogiadung/views/ThongBao/ThongBao.dart';
import 'package:flutter/material.dart';

import '../../controllers/ThongBaoController.dart';
import '../../models/TBKH.dart';
import '../../models/ThongBao.dart';


class NotificationScreen extends StatefulWidget {
  final String maKhachHang;

  NotificationScreen({required this.maKhachHang});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<TBKH>> futureTBKHList;
  ThongBaoController thongBaoController = ThongBaoController();

  @override
  void initState() {
    super.initState();
    futureTBKHList = thongBaoController.fetchTBKH(widget.maKhachHang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<TBKH>>(
        future: futureTBKHList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load notifications"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No notifications found"));
          }else{
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreenEmpty()),
              );
            });
            return SizedBox.shrink(); // Avoid returning any widget while waiting for navigation

          }

          List<TBKH> tbkhList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: tbkhList.length,
            itemBuilder: (context, index) {
              TBKH tbkh = tbkhList[index];
              return FutureBuilder<ThongBao>(
                future: thongBaoController.fetchThongBao(tbkh.maTBKH),
                builder: (context, tbSnapshot) {
                  if (tbSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (tbSnapshot.hasError) {
                    return Center(child: Text("Failed to load notification content"));
                  } else if (tbSnapshot.hasData) {
                    ThongBao thongBao = tbSnapshot.data!;
                    return NotificationItem(
                      icon: Icons.notifications_outlined,
                      iconColor: tbkh.daXem ? Colors.grey : Colors.red,
                      message: thongBao.noiDung,
                    );
                  } else {
                    return SizedBox.shrink(); // Không hiển thị gì nếu không có dữ liệu
                  }
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String message;

  const NotificationItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
