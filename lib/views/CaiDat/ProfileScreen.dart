import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:flutter/material.dart';

import '../../models/KhachHang.dart';

class ProfileScreen extends StatefulWidget {
  final String makh;


  const ProfileScreen({
    Key? key,
    required this.makh,

  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  KhachHangController khachHangService = KhachHangController();
  KhachHang? khachHang;

  @override
  void initState() {
    super.initState();
    fetchKhachHang();
  }
  Future<void> fetchKhachHang() async {
    KhachHang? fetchedKhachHang = await KhachHangController().getKhachHang('KH1');
    setState(() {
      khachHang = fetchedKhachHang;
    });
  }

  @override
  Widget build(BuildContext context) {
    String name=utf8.decode(khachHang!.tenKH.runes.toList());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(''),
              ),
              SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Text(
                      'Chỉnh sửa',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildMenuItem('Địa chỉ giao hàng', Icons.location_on),
              _buildMenuItem('Sản phẩm yêu thích', Icons.favorite),
              _buildMenuItem('Hỗ trợ', Icons.help),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Handle logout
                },
                child: Text('Đăng xuất',
                    style: TextStyle(fontSize: 18, color: Colors.red)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black54),
          SizedBox(width: 16),
          Text(title, style: TextStyle(fontSize: 18)),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ],
      ),
    );
  }

}