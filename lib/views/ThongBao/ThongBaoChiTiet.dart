import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ThongBaoController.dart';
import 'package:datn_cntt304_bandogiadung/models/ThongBao.dart';
import 'package:datn_cntt304_bandogiadung/models/TBKH.dart';
import 'package:intl/intl.dart';

import '../../controllers/TBKHController.dart';

class NotificationDetailScreen extends StatefulWidget {
  final TBKH tbkh;
  final ThongBao thongBao;

  NotificationDetailScreen({required this.tbkh, required this.thongBao});

  @override
  _NotificationDetailScreenState createState() => _NotificationDetailScreenState();
}
final ColorScheme colorScheme = ColorScheme.fromSeed(
seedColor: Colors.blue,
primary: Colors.blue,
secondary: Colors.orange,
surface: Colors.white,
background: Colors.grey[100]!,
error: Colors.red,
);
class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  final TBKHController _thongBaoController = TBKHController();

  @override
  void initState() {
    super.initState();
    _updateNotificationStatus();
  }

  void _updateNotificationStatus() async {
    if (!widget.tbkh.daXem) {
      try {
        TBKH updatedTBKH = TBKH(
          maTBKH: widget.tbkh.maTBKH,
          khachHang: widget.tbkh.khachHang,
          daXem: true,
        );
        await _thongBaoController.updateTBKH(updatedTBKH);
      } catch (e) {
        print('Error updating notification status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết thông báo'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.thongBao.noiDung,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Ngày thông báo: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.thongBao.ngayTB)}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            // Add more details here if needed
          ],
        ),
      ),
    );
  }
}

