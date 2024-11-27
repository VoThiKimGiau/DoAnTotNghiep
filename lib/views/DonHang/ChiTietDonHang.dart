import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/controllers/DonHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/GiaoHangController.dart';
import 'package:datn_cntt304_bandogiadung/views/DoiTra/DanhSachSanPhamDoiTra.dart';
import 'package:datn_cntt304_bandogiadung/views/DonHang/HuyDH.dart';
import 'package:datn_cntt304_bandogiadung/views/DonHang/TBTraHang.dart';
import 'package:flutter/material.dart';
import '../../models/GiaoHang.dart';
import '/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:datn_cntt304_bandogiadung/models/TTNhanHang.dart';
import 'package:datn_cntt304_bandogiadung/views/DonHang/DanhSachSanPham.dart';
import 'package:datn_cntt304_bandogiadung/controllers/TTNhanHangController.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final DonHang donHang;
  final int productCount;

  OrderDetailScreen({required this.donHang, required this.productCount});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  TTNhanHang? tTNhanHang;
  bool isLoading = true;
  GiaoHang? giaoHang;
  @override
  void initState() {
    super.initState();
    fetchGiaoHang();
    fetchTTNhanHang();
  }

  Future<void> updateStatus(String orderId,String newStatus) async{
    DonHangController donHangController=DonHangController();
    try{
      donHangController.updateOrderStatus(orderId, newStatus);
    }catch(error)
    {
      print("Error: +$error");
    }
  }
  Future<void> fetchGiaoHang() async {
    GiaoHangController controller = GiaoHangController();
    try {
      giaoHang = await controller.fetchGiaoHang(widget.donHang.maDH);
    } catch (error) {
      print('Failed to load GiaoHang: $error');
    }
  }
  Future<void> fetchTTNhanHang() async {
    TTNhanHangController controller = TTNhanHangController();
    try {
      tTNhanHang =
          await controller.fetchTTNhanHang(widget.donHang.thongTinNhanHang);
    } catch (error) {
      print('Failed to load TTNhanHang: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Đơn hàng #${widget.donHang.maDH}'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 25),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderStatus(),
              const SizedBox(height: 24.0),
              const Text('Chi tiết đơn hàng',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87)),
              const SizedBox(height: 12.0),
              _buildProductDetails(context),
              const SizedBox(height: 24.0),
              const Text('Địa chỉ',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87)),
              const SizedBox(height: 12.0),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildAddressDetails(),
              const SizedBox(height: 24.0),
              if (_isCancelButtonVisible())
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Màu nền của nút
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12), // Padding cho nút
                    ),
                    onPressed: () {
                      updateStatus(widget.donHang.maDH, "Đã huỷ");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HuyDHScreen(
                                    maKH: widget.donHang.khachHang,
                                  )));
                    },
                    child: const Text('Hủy đơn hàng',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18)), // Nội dung của nút
                  ),
                ),
              if (_isConfirmButtonsVisible())
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          onPressed: () {
                            updateStatus(widget.donHang.maDH, "Đã giao hàng");
                          },
                          child: const Text(
                            'Đã nhận hàng',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              if (_isButtonsVisible())
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellowAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => Danhsachsanphamdoitra(
                            donHang: widget.donHang,
                            )));
                          },
                          child: const Text(
                            'Trả hàng hoàn tiền',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(String status, bool isActive, {String? date}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: isActive ? AppColors.primaryColor : Colors.grey.shade400,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 20,
                    color: isActive ? AppColors.primaryColor : Colors.black54,
                  ),
                ),
                if (date != null && date.isNotEmpty)
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    String decodedStatus =utf8.decode( widget.donHang.trangThaiDH.runes.toList());
    bool isDelivered = decodedStatus == 'Đã giao hàng';
    bool isShipping = decodedStatus == 'Đang giao hàng' || isDelivered;
    bool isConfirmed = decodedStatus == 'Đã xác nhận' || isShipping;
    bool isProcessing = decodedStatus == 'Đang xử lý' || isConfirmed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trạng thái đơn hàng',
            style: TextStyle(
                fontFamily: 'Comfortaa', fontSize: 22, color: Colors.black87)),
        const SizedBox(height: 12.0),
        _buildStatusItem('Đã giao hàng', isDelivered, date: giaoHang?.ngayGiao != null
            ? DateFormat('dd/MM/yyyy').format((giaoHang!.ngayGiao!! ))
            : ''),
        _buildStatusItem('Đang giao hàng', isShipping, date: giaoHang?.ngayGui != null
            ? DateFormat('dd/MM/yyyy').format((giaoHang!.ngayGui!!))
            : ''),
        _buildStatusItem('Đã xác nhận', isConfirmed, date: giaoHang?.ngayGiao != null
            ? DateFormat('dd/MM/yyyy').format((giaoHang!.ngayGui!! ))
            : ''),
        _buildStatusItem('Đang xử lý', isProcessing,
            date: DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(widget.donHang.ngayDat.toString()))),
      ],
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.shopping_cart, color: Colors.black54, size: 28),
          Text(
            '${widget.productCount} sản phẩm',
            style: const TextStyle(
                fontSize: 18, color: Colors.black87),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSummary(donHang: widget.donHang),
                ),
              );
            },
            child: const Text(
              'Xem tất cả',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressDetails() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tTNhanHang?.diaChi ?? 'Địa chỉ không có sẵn',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Edit address action
            },
            child: const Text(
              'Sửa',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCancelButtonVisible() {
    String decodedStatus =utf8.decode(widget.donHang.trangThaiDH.runes.toList()) ;
    return decodedStatus == 'Đang xử lý' || decodedStatus == 'Đã xác nhận';
  }

  bool _isConfirmButtonsVisible() {
    String decodedStatus =utf8.decode(widget.donHang.trangThaiDH.runes.toList());
    return decodedStatus == 'Đang giao hàng';
  }
  bool _isButtonsVisible() {
    String decodedStatus =utf8.decode(widget.donHang.trangThaiDH.runes.toList());
    return decodedStatus == 'Đã giao hàng';
  }
}
