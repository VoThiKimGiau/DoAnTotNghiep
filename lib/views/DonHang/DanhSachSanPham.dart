import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DonHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/GiaoHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KMDHController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
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
  late MauSPController mauSPController=MauSPController();
  late KichCoController kichCoController=KichCoController();
  late ChiTietSPController chiTietSPController=ChiTietSPController();
  late DonHangController donHangController=DonHangController();
  @override
  void initState() {
    super.initState();

    _orderDetails = ChiTietDonHangController().fetchListProduct(widget.donHang.maDH);
    _khuyenmai = KMDHController().fetchKMDH(widget.donHang.maDH);
  }
  Future<DonHang> layDonHang(String maDH) async
  {
    DonHang donHang=await donHangController.fetchDetailDonHang(maDH);
    if (donHang!=null)
    {
      return donHang;
    }
    else
      throw Exception("Loi lay don hàng theo mã");
  }
  Future<String> layTenMau(String maMau) async
  {
    String tenMau='';
    try {
      tenMau = await mauSPController.layTenMauByMaMau(maMau);
      return tenMau;
    } catch (error) {
      return 'Lỗi hiển thị màu';
    }
  }
  Future<String> layTenKichCo(String maKichCo) async
  {
    String tenKC='';
    try {
      tenKC = await kichCoController.layTenKichCo(maKichCo);
      return tenKC;
    } catch (error) {
      return 'Lỗi hiển thị kích cỡ';
    }
  }
  Future<ChiTietSP> layCTSP(String maCTSP) async{
    ChiTietSP chiTietSP= await chiTietSPController.layCTSPTheoMa(maCTSP);
    if(chiTietSP!=null)
    {
      return chiTietSP;
    }
    else
      throw Exception('Không tìm thấy ChiTietSP với mã: $maCTSP');
  }
  Future<String?> layTenSP(String masp) async
  {
    String? ten=await _sanPhamController.getProductNameByMaSP(masp);
    if(ten!="")
    {
      return ten;
    }
    else
      throw Exception("Lay tên sản phẩm thất bại !");
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

          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(String maCTSP, String quantity, String price) {
    return FutureBuilder<ChiTietSP>(
      future: chiTietSPController.layCTSPTheoMa(maCTSP),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          ChiTietSP? chiTietSP = snapshot.data;

          // Create a list of futures
          List<Future<String>> futures = [
            layTenSP(chiTietSP?.maSP ?? '').then((value) => value ?? 'Unknown Product'),
            layTenMau(chiTietSP?.maMau ?? '').then((value) => value ?? 'Unknown Color'),
            layTenKichCo(chiTietSP?.maKichCo ?? '').then((value) => value ?? 'Unknown Size'),
          ];

          return FutureBuilder<List<String>>(
            future: Future.wait(futures), // Wait for all futures to complete
            builder: (context, productDetailsSnapshot) {
              if (productDetailsSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (productDetailsSnapshot.hasError) {
                return Text('Error: ${productDetailsSnapshot.error}');
              } else {
                final productDetails = productDetailsSnapshot.data ?? ['', '', ''];
                String decodeName = utf8.decode(productDetails[0].runes.toList());
                String tenKichCo = productDetails[2];
                String tenMau = productDetails[1];

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
                            '$decodeName\n$tenKichCo - $tenMau',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 4),
                          Text(quantity, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(price, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                );
              }
            },
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
