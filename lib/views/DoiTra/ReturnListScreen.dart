import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/DoiTraController.dart';
import '../../models/DoiTra.dart';
import 'ReturnDetailScreen.dart';


class ReturnListScreen extends StatefulWidget {
  @override
  _ReturnListScreenState createState() => _ReturnListScreenState();
}

class _ReturnListScreenState extends State<ReturnListScreen> {
  final DoiTraController _doiTraController = DoiTraController();
  late Future<List<DoiTra>> _doiTraList;

  @override
  void initState() {
    super.initState();
    _doiTraList = _doiTraController.getDoiTraList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý danh sách trả hàng hoàn tiền', style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<DoiTra>>(
        future: _doiTraList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn đổi trả nào.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              DoiTra doiTra = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Mã đổi trả: ${doiTra.maDoiTra}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đơn hàng: ${doiTra.donHang}', style: TextStyle(fontSize: 18)),
                      Text('Trạng thái: ${utf8.decode( doiTra.trangThai.runes.toList())}', style: TextStyle(fontSize: 18)),
                      Text('Ngày đổi trả: ${DateFormat('dd/MM/yyyy').format(doiTra.ngayDoiTra ?? DateTime.now())}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReturnDetailScreen(doiTra: doiTra),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}