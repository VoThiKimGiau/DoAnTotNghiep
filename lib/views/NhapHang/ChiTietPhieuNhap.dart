import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/controllers/PhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/DanhSachCTSP.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietPhieuNhap.dart';
import '../../models/PhieuNhap.dart';

class OrderStatusScreen extends StatefulWidget {
  final PhieuNhap pn;
  OrderStatusScreen({required this.pn});

  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  late Future<List<ChiTietPhieuNhap>> _chiTietPhieuNhapFuture = ChiTietPhieuNhapController().layDanhSachChiTietPhieuNhap("0");  // Giá trị tạm thời
  late PhieuNhapController phieuNhapController=PhieuNhapController();
  bool isButtonDisabled = false;
  @override
  void initState() {
    super.initState();
    _chiTietPhieuNhapFuture = ChiTietPhieuNhapController().layDanhSachChiTietPhieuNhap(widget.pn.maPhieuNhap);
    print(widget.pn.trangThai);
  }

  @override
  Widget build(BuildContext context) {
    String formatTrangThai = utf8.decode(widget.pn.trangThai.runes.toList());

    bool isReceived = formatTrangThai == 'Đã nhận hàng';
    bool isConfirmed = formatTrangThai == 'Đã xác nhận';
    bool isProcessing = formatTrangThai == 'Đang xử lý';

    bool showReceivedCheck = isReceived;
    bool showConfirmedCheck = isReceived || isConfirmed;
    bool showProcessingCheck = isReceived || isConfirmed || isProcessing;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('#${widget.pn.maPhieuNhap}', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildStatusItem('Đã nhận hàng', showReceivedCheck),
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                    _buildStatusItem('Đã xác nhận', showConfirmedCheck),
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                    _buildStatusItem('Đang xử lý', showProcessingCheck),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Chi tiết phiếu nhập',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(height: 10),
              FutureBuilder<List<ChiTietPhieuNhap>>(
                future: _chiTietPhieuNhapFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Lỗi khi tải dữ liệu"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Không có dữ liệu"));
                  } else {
                    return _buildOrderDetails(snapshot.data!);
                  }
                },
              ),
              if (!isReceived)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: isButtonDisabled ? null : () async {
                      setState(() {
                        isButtonDisabled = true;
                      });
                      await phieuNhapController.updatePhieuNhapDaGiao(widget.pn.maPhieuNhap); // Gọi hàm cập nhật
                    },
                    child: Text('Đã nhập hàng'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, bool isCompleted) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.blue : Colors.grey[300],
            ),
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
              color: isCompleted ? Colors.black : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(List<ChiTietPhieuNhap> chiTietPhieuNhapList) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${chiTietPhieuNhapList.length} sản phẩm',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Comfortaa',
                  ),
                  overflow: TextOverflow.ellipsis, // Handle overflow
                  maxLines: 1, // Limit to one line
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the detailed list of product details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DanhSachCTSP(pn: widget.pn),
                    ),
                  );
                },
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}