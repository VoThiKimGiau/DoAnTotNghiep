import 'package:datn_cntt304_bandogiadung/assets/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DonHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:datn_cntt304_bandogiadung/views/DonHang/ChiTietDonHang.dart';
import 'package:datn_cntt304_bandogiadung/views/DonHang/DonHang.dart';
class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  String selectedStatus = 'Đang xử lý';

  final List<DonHang> donHangs = DonHangController.getDonHangs();

  @override
  Widget build(BuildContext context) {
    List<DonHang> filteredOrders = donHangs
        .where((order) => order.trangThaiDH == selectedStatus)
        .toList();
    DonHangController.fetchOrderDetail();


    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18
        ),
      ),
      body: Column(
        children: [
          // Horizontal ListView for filtering order statuses
          Container(
            margin: EdgeInsets.only(top: 16.0),
            height: 50.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatusButton('Đang xử lý'),
                _buildStatusButton('Đang giao'),
                _buildStatusButton('Đã nhận hàng'),
                _buildStatusButton('Đã xác nhận'),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          SizedBox(height: 16.0),

          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final donHang = filteredOrders[index];
                final proCount=DonHangController().countProductsByOrderId(donHang.maDH);
                return OrderCard(
                  orderNumber: donHang.maDH,
                  productCount: proCount,
                  status: donHang.trangThaiDH,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the status button
  Widget _buildStatusButton(String status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = status;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selectedStatus == status ? AppColors.primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          status,

          style: TextStyle(fontSize: 16,fontFamily:'Comfortaa',fontWeight: FontWeight.w700,
            color: selectedStatus == status ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final int productCount;
  final String status;

  const OrderCard({
    required this.orderNumber,
    required this.productCount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0), // Margin between cards
      elevation: 4, // Add shadow for depth
      child: ListTile(
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
                    'Đơn hàng $orderNumber',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Số lượng sản phẩm: $productCount ',
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
          // Truyền productId khi nhấn vào sản phẩm
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(maDH:orderNumber),
            ),
          );
        },
      ),
    );
  }
}