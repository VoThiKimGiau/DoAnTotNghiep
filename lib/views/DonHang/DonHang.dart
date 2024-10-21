import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DonHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:flutter_svg/svg.dart';

import 'ChiTietDonHang.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietDonHangController.dart';

class OrderListScreen extends StatefulWidget {
  final String? maKH;

  const OrderListScreen({required this.maKH, Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<DonHang>> futureDonHangs;

  @override
  void initState() {
    super.initState();
    futureDonHangs = DonHangController().fetchDonHang(widget.maKH);
  }

  Future<int> _fetchProductCount(String madh) async {
    return await ChiTietDonHangController().fetchProductCount(madh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Đơn hàng',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontFamily: 'Comfortaa',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<DonHang>>(
        future: futureDonHangs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Có lỗi xảy ra: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Không có đơn hàng nào.',
                style: TextStyle(fontSize: 18, fontFamily: 'Comfortaa'),
              ),
            );
          }

          List<DonHang> donHangs = snapshot.data!;

          return ListView.separated(
            itemCount: donHangs.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final donHang = donHangs[index];

              return FutureBuilder<int>(
                future: _fetchProductCount(donHang.maDH),
                builder: (context, productCountSnapshot) {
                  if (productCountSnapshot.connectionState == ConnectionState.waiting) {
                    return _buildOrderTile(donHang, 'Đang lấy số lượng sản phẩm...', null);
                  } else if (productCountSnapshot.hasError) {
                    return _buildOrderTile(donHang, 'Có lỗi xảy ra', null);
                  }

                  int productCount = productCountSnapshot.data ?? 0;
                  return _buildOrderTile(donHang, 'Số lượng sản phẩm: $productCount', productCount);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderTile(DonHang donHang, String subtitle, int? productCount) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: SvgPicture.asset(
        'assets/icons/order.svg',
        width: 32,
        height: 32,
        color: Colors.blue,
      ),
      title: Text(
        'Đơn hàng: ${donHang.maDH}',
        style: TextStyle(
          fontSize: 22, // Updated text size for ListTile title
          fontFamily: 'Comfortaa',
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 20, // Updated text size for ListTile subtitle
          fontFamily: 'Comfortaa',
          color: Colors.grey[700],
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
              donHang: donHang,
              productCount: productCount ?? 0,
            ),
          ),
        );
      },
    );
  }
}
