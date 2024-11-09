import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/TaiKhoanController.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:flutter/material.dart';
import '../../models/KhachHang.dart';
import 'SanPhamYeuThich.dart';

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
    KhachHang? fetchedKhachHang =
        await KhachHangController().getKhachHang(widget.makh);
    setState(() {
      khachHang = fetchedKhachHang;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (khachHang == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    String name = khachHang!.tenKH ?? "Tên chưa đăng ký";
    String email = khachHang!.email ?? "Email chưa đăng ký";
    String phone = khachHang!.sdt ?? "Số điện thoại chưa đăng ký";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Handle edit profile action
                    },
                    child: const Text(
                      'Chỉnh sửa',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildMenuItem('Địa chỉ giao hàng', Icons.location_on, () {
                // Handle navigation if needed
              }),
              _buildMenuItem('Sản phẩm yêu thích', Icons.favorite, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SanPhamYeuThichScreen(
                            maKH: widget.makh,
                          )),
                );
              }),
              _buildMenuItem('Hỗ trợ', Icons.help, () {
                // Handle support action if needed
              }),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmationDialog();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  elevation: 2,
                ),
                child: const Text('Đăng xuất',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black54),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Đồng ý"),
              onPressed: () {
                Navigator.of(context).pop();

                // Proceed with logout
                KhachHangController controller = KhachHangController();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
