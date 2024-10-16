import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/controllers/GiaoHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KMDHController.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:datn_cntt304_bandogiadung/models/GiaoHang.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import '../../models/ChiTietDonHang.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietDonHangController.dart';

import 'package:datn_cntt304_bandogiadung/models/KMDH.dart';
class OrderSummary extends StatefulWidget {
  final DonHang donHang;

  const OrderSummary({Key? key, required this.donHang}) : super(key: key);

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  late Future<List<ChiTietDonHang>> _orderDetails;
  late Future<GiaoHang?> _giaoHang;
  late Future<List<KMDH>> _khuyenmai;
  final SanPhamController _sanPhamController = SanPhamController();

  @override
  void initState() {
    super.initState();
    _giaoHang = GiaoHangController().fetchGiaoHang(widget.donHang.maDH);
    _orderDetails = ChiTietDonHangController().fetchListProduct(widget.donHang.maDH);
    _khuyenmai = KMDHController().fetchKMDH(widget.donHang.maDH);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Đơn hàng #${widget.donHang.maDH}', style: TextStyle(color: Colors.black, fontSize: 25)), // Updated to 25
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<ChiTietDonHang>>(
                future: _orderDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No order details found.'));
                  } else {
                    return ListView(
                      children: snapshot.data!.map((item) {
                        Widget productItem = _buildProductItem(
                            item.sanPham,
                            item.kichCo,
                            item.mauSP,
                            'SL ${item.soLuong}',
                            '\$${item.donGia}'
                        );
                        return Column(
                          children: [
                            productItem,
                            SizedBox(height: 8), // Adjust height as needed
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            FutureBuilder<List<KMDH>>(
              future: _khuyenmai,
              builder: (context, kmSnapshot) {
                if (kmSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (kmSnapshot.hasError) {
                  return Text('Error: ${kmSnapshot.error}');
                } else if (!kmSnapshot.hasData || kmSnapshot.data == null) {
                  return Text('No promotion applied.');
                } else {
                  List<KMDH> promotions = kmSnapshot.data!;
                  String promotionCodes = promotions.map((khuyenMai) => khuyenMai.khuyenMai).join(', ');
                  return _buildSummaryItem('Áp dụng khuyến mãi', promotionCodes, fontSize: 20); // Updated to 20
                }
              },
            ),
            FutureBuilder<GiaoHang?>(
              future: _giaoHang,
              builder: (context, giaoHangSnapshot) {
                if (giaoHangSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (giaoHangSnapshot.hasError) {
                  return Text('Error: ${giaoHangSnapshot.error}');
                } else if (!giaoHangSnapshot.hasData || giaoHangSnapshot.data == null) {
                  return Text('NaN.');
                } else {
                  GiaoHang giaoHang = giaoHangSnapshot.data!;
                  String decodedHinhThuc = utf8.decode(giaoHang.hinhThuc.runes.toList());
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryItem('Hình thức vận chuyển', decodedHinhThuc, fontSize: 20), // Updated to 20
                      _buildSummaryItem('Phí giao hàng', '\$8.00', fontSize: 20), // Updated to 20
                      Divider(),
                      _buildSummaryItem('Tổng cộng', '\$${widget.donHang.thanhTien}', isBold: true, fontSize: 22), // Updated to 22
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(String maSP, String kichCo, String mau, String quantity, String price) {
    return FutureBuilder<String?>(
      future: _sanPhamController.getProductNameByMaSP(maSP),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String productName = snapshot.data ?? 'Unknown Product';
          String decodeName = utf8.decode(productName.runes.toList());
          return Row(
            children: [
              Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      decodeName + '\n' + kichCo + '-' + mau,
                      style: TextStyle(fontSize: 20), // Updated to 20
                    ),
                    SizedBox(height: 4),
                    Text(quantity, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Text(price, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Updated to 20
            ],
          );
        }
      },
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isBold = false, double fontSize = 18}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: fontSize)), // Adjusted fontSize
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 22 : fontSize, // Adjusted fontSize
            ),
          ),
        ],
      ),
    );
  }
}


  Widget _buildSummaryItem(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }
