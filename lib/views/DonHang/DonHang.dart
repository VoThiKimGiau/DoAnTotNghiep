import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DonHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:flutter_svg/svg.dart';

import 'ChiTietDonHang.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietDonHangController.dart';

class OrderListScreen extends StatefulWidget {
  final String maKH; // Thêm tham số để truyền mã khách hàng

  const OrderListScreen({required this.maKH, Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<DonHang>> futureDonHangs;

  @override
  void initState() {
    super.initState();
    // Khởi tạo futureDonHangs với hàm fetchDonHang
    futureDonHangs = DonHangController().fetchDonHang(widget.maKH);
  }

  Future<int> _fetchProductCount(String madh) async {
    return await ChiTietDonHangController().fetchProductCount(madh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      body: FutureBuilder<List<DonHang>>(
        future: futureDonHangs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn hàng nào.'));
          }

          List<DonHang> donHangs = snapshot.data!;

          return ListView.builder(
            itemCount: donHangs.length,
            itemBuilder: (context, index) {
              final donHang = donHangs[index];

              return FutureBuilder<int>(
                future: _fetchProductCount(donHang.maDH), // Gọi hàm để lấy số lượng sản phẩm
                builder: (context, productCountSnapshot) {
                  if (productCountSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Đơn hàng: ${donHang.maDH}'),
                      subtitle: Text('Đang lấy số lượng sản phẩm...'),
                    );
                  } else if (productCountSnapshot.hasError) {
                    return ListTile(
                      title: Text('Đơn hàng: ${donHang.maDH}'),
                      subtitle: Text('Có lỗi xảy ra: ${productCountSnapshot.error}'),
                    );
                  }

                  int productCount = productCountSnapshot.data ?? 0; // Lấy số lượng sản phẩm

                  // Tạo UI cho từng đơn hàng
                  return ListTile(
                    contentPadding: EdgeInsets.all(16.0), // Padding inside the card
                    title: Row(
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/order.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đơn hàng: ${donHang.maDH}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Số lượng sản phẩm: $productCount',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Comfortaa',
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 24,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(maDH: donHang.maDH),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
