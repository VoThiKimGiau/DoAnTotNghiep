import 'package:datn_cntt304_bandogiadung/views/ThongBao/ThongBaoChiTiet.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ThongBaoController.dart';
import 'package:datn_cntt304_bandogiadung/models/TBKH.dart';
import 'package:datn_cntt304_bandogiadung/models/ThongBao.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  primary: Colors.blue,
  secondary: Colors.orange,
  surface: Colors.white,
  background: Colors.grey[100]!,
  error: Colors.red,
);

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

  void _navigateToDetailScreen(TBKH tbkh, ThongBao thongBao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailScreen(tbkh: tbkh, thongBao: thongBao),
      ),
    ).then((_) {
      // Refresh the list when returning from the detail screen
      setState(() {
        futureTBKHList = thongBaoController.fetchTBKH(widget.maKhachHang);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Thông báo',
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: FutureBuilder<List<TBKH>>(
        future: futureTBKHList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load notifications", style: TextStyle(color: colorScheme.error)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NotificationScreenEmpty();
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
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                    );
                  } else if (tbSnapshot.hasError) {
                    return Center(child: Text("Failed to load notification content", style: TextStyle(color: colorScheme.error)));
                  } else if (tbSnapshot.hasData) {
                    ThongBao thongBao = tbSnapshot.data!;
                    return GestureDetector(
                      onTap: () => _navigateToDetailScreen(tbkh, thongBao),
                      child: NotificationItem(
                        icon: Icons.notifications_outlined,
                        iconColor: tbkh.daXem ? colorScheme.onSurface.withOpacity(0.5) : colorScheme.primary,
                        message: thongBao.noiDung,
                      ),
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

// ... (rest of the code remains the same)


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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
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
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationScreenEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('Thông báo'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: colorScheme.primary.withOpacity(0.5),
            ),
            SizedBox(height: 24),
            Text(
              'Tạm thời không có thông báo',
              style: TextStyle(
                fontSize: 20,
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to the home page or perform any action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Trở về trang chủ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}