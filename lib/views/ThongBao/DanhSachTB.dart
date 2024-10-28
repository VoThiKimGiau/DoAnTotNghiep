import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/views/ThongBao/ThongBao.dart';
import 'package:flutter/material.dart';

import '../../controllers/ThongBaoController.dart';
import '../../models/TBKH.dart';
import '../../models/ThongBao.dart';


class NotificationScreen extends StatefulWidget {
  final String? maKhachHang;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Thông báo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreenEmpty()),
              );
            });
            return SizedBox.shrink();
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
                      iconColor: tbkh.daXem ? Colors.grey :AppColors.primaryColor,
                      message: thongBao.noiDung,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            },
          );
        },
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}