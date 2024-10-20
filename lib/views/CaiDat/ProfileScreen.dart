import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/TaiKhoanController.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:flutter/material.dart';

import '../../models/KhachHang.dart';

class ProfileScreen extends StatefulWidget {
  final String? makh;


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
    KhachHang? fetchedKhachHang = await KhachHangController().getKhachHang(widget.makh);
    setState(() {
      khachHang = fetchedKhachHang;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (khachHang == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    String name = utf8.decode((khachHang!.tenKH?.runes.toList()) ?? []);
    String email = khachHang!.email ?? "Email chưa đăng ký"; // Default message if email is null
    String phone = khachHang!.sdt ?? "Số điện thoại chưa đăng ký"; // Default message if phone is null

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(''), // Add a proper image URL if needed
              ),
              SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: TextStyle(fontSize: 16, color: Colors.black54), // Style for email
              ),
              SizedBox(height: 4),
              Text(
                phone,
                style: TextStyle(fontSize: 16, color: Colors.black54), // Style for phone number
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Handle edit profile action
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
                  _showLogoutConfirmationDialog();
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
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận"),
          content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Đồng ý"),
              onPressed: () {
                Navigator.of(context).pop();

                // Proceed with logout
                KhachHangController controller = new KhachHangController();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false, // Remove all routes from the stack
                );
              },
            ),
          ],
        );
      },
    );
  }


}