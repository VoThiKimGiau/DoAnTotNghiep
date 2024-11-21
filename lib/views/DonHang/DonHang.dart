import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DonHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietDonHangController.dart';
import 'ChiTietDonHang.dart';
import 'OrderListFilters.dart';

class OrderListScreen extends StatefulWidget {
  final String? maKH;

  const OrderListScreen({required this.maKH, Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<DonHang>> futureDonHangs;
  String? selectedStatus;
  DateTime? selectedDate;

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    primary: Colors.blue,
    secondary: Colors.orange,
    surface: Colors.white,
    background: Colors.grey[100]!,
    error: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    _fetchDonHangs();
  }

  void _fetchDonHangs() {
    futureDonHangs = DonHangController().fetchDonHang(
      widget.maKH,
      status: selectedStatus,
      date: selectedDate,
    );
  }

  Future<int> _fetchProductCount(String madh) async {
    return await ChiTietDonHangController().fetchProductCount(madh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Đơn hàng',
          style: TextStyle(
            fontSize: 25,
            color: colorScheme.onPrimary,
            fontFamily: 'Comfortaa',
            
          ),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: OrderListFilters(
              onStatusChanged: (String? newStatus) {
                setState(() {
                  selectedStatus = newStatus;
                  _fetchDonHangs();
                });
              },
              onDateChanged: (DateTime? newDate) {
                setState(() {
                  selectedDate = newDate;
                  _fetchDonHangs();
                });
              },
              selectedStatus: selectedStatus,
              selectedDate: selectedDate,

            ),
          ),
          Expanded(
            child: FutureBuilder<List<DonHang>>(
              future: futureDonHangs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: colorScheme.primary));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Có lỗi xảy ra: ${snapshot.error}',
                      style: TextStyle(color: colorScheme.error, fontSize: 16),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Không có đơn hàng nào.',
                      style: TextStyle(fontSize: 18, fontFamily: 'Comfortaa', color: colorScheme.onBackground),
                    ),
                  );
                }

                List<DonHang> donHangs = snapshot.data!;

                return ListView.builder(
                  itemCount: donHangs.length,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    final donHang = donHangs[index];

                    return FutureBuilder<int>(
                      future: _fetchProductCount(donHang.maDH),
                      builder: (context, productCountSnapshot) {
                        if (productCountSnapshot.connectionState == ConnectionState.waiting) {
                          return _buildOrderCard(donHang, 'Đang lấy số lượng sản phẩm...', null);
                        } else if (productCountSnapshot.hasError) {
                          return _buildOrderCard(donHang, 'Có lỗi xảy ra', null);
                        }

                        int productCount = productCountSnapshot.data ?? 0;
                        return _buildOrderCard(donHang, 'Số lượng sản phẩm: $productCount', productCount);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(DonHang donHang, String subtitle, int? productCount) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/order.svg',
                      width: 24,
                      height: 24,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Đơn hàng: ${donHang.maDH}',
                      style: TextStyle(
                        fontSize: 18,

                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.primary),
                ],
              ),
              SizedBox(height: 12),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Trạng thái: ${utf8.decode(donHang.trangThaiDH.runes.toList())}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Ngày đặt: ${donHang.ngayDat.day}/${donHang.ngayDat.month}/${donHang.ngayDat.year}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

