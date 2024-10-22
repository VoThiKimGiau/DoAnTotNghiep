import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietPhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';

import '../../controllers/ChiTietSPController.dart';
import '../../models/ChiTietSP.dart';

class DanhSachCTSP extends StatefulWidget {
  final PhieuNhap pn;
  const DanhSachCTSP({Key? key, required this.pn}) : super(key: key);

  @override
  _DanhSachCTSPState createState() => _DanhSachCTSPState();
}




class _DanhSachCTSPState extends State<DanhSachCTSP> {
  late Future<List<ChiTietPhieuNhap>> _chiTietPhieuNhapFuture;
  final ChiTietPhieuNhapController chiTietPhieuNhapController = ChiTietPhieuNhapController();
  final StorageService storageService = StorageService();
  final ChiTietSPController chiTietSPController=ChiTietSPController();
  @override
  void initState() {
    super.initState();
    _chiTietPhieuNhapFuture = chiTietPhieuNhapController.layDanhSachChiTietPhieuNhap(widget.pn.maPhieuNhap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Phiếu nhập #${widget.pn.maPhieuNhap}',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<ChiTietPhieuNhap>>(
        future: _chiTietPhieuNhapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có chi tiết phiếu nhập.'));
          }

          final chiTietList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: chiTietList.length,
            itemBuilder: (context, index) {
              final chiTiet = chiTietList[index];

              // Fetch product details asynchronously
              return FutureBuilder<ChiTietSP>(
                future: chiTietSPController.layCTSPTheoMa(chiTiet.maCTSP),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (productSnapshot.hasError) {
                    return Text('Lỗi tải chi tiết sản phẩm: ${productSnapshot.error}');
                  } else if (!productSnapshot.hasData) {
                    return Text('Không tìm thấy chi tiết sản phẩm.');
                  }

                  // Get the product details
                  final productDetails = productSnapshot.data!;

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Image on the left
                          Image.network(
                            storageService.getImageUrl(productDetails.maHinhAnh), // Assuming hinhAnh is the field containing the image URL
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 16), // Spacing between image and text
                          Expanded( // Allows product details to take up remaining space
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Mã CTSP: ${chiTiet.maCTSP}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'SL: ${chiTiet.soLuong}',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                _buildInfoRow('Đơn giá', '${chiTiet.donGia.toStringAsFixed(0)}đ'),
                                _buildInfoRow('Thành tiền', '${(chiTiet.donGia * chiTiet.soLuong).toStringAsFixed(0)}đ'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}
