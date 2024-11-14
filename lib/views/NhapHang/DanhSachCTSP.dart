import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietPhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';

import '../../controllers/ChiTietSPController.dart';
import '../../controllers/KichCoController.dart';
import '../../controllers/MauSPController.dart';
import '../../controllers/SanPhamController.dart';
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
  final SanPhamController _sanPhamController = SanPhamController();
  late MauSPController mauSPController=MauSPController();
  late KichCoController kichCoController=KichCoController();
  SharedFunction sharedFunction=SharedFunction();
  @override
  void initState() {
    super.initState();
    _chiTietPhieuNhapFuture = chiTietPhieuNhapController.layDanhSachChiTietPhieuNhap(widget.pn.maPhieuNhap);
  }
  Future<String> layTenMau(String maMau) async
  {
    String tenMau='';
    try {
      tenMau = await mauSPController.layTenMauByMaMau(maMau);
      String mau=utf8.decode(tenMau.runes.toList());
      return mau;
    } catch (error) {
      return 'Lỗi hiển thị màu';
    }
  }
  Future<String> layTenKichCo(String maKichCo) async
  {
    String tenKC='';
    try {
      tenKC = await kichCoController.layTenKichCo(maKichCo);
      String kc=utf8.decode(tenKC.runes.toList());
      return kc;
    } catch (error) {
      return 'Lỗi hiển thị kích cỡ';
    }
  }

  Future<String> layTenSP(String masp) async {
    String? ten = await _sanPhamController.getProductNameByMaSP(masp);
    return ten ?? 'Tên sản phẩm không tìm thấy'; // Provide a default value if null
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

                  final productDetails = productSnapshot.data!;

                  return FutureBuilder<String>(
                    future: layTenSP(productDetails.maSP),
                    builder: (context, tenSPSnapshot) {
                      if (tenSPSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (tenSPSnapshot.hasError) {
                        return Text('Lỗi tải tên sản phẩm: ${tenSPSnapshot.error}');
                      }

                      // Lấy tên màu và kích cỡ
                      return FutureBuilder<List<String>>(
                        future: Future.wait([
                          layTenMau(productDetails.maMau),
                          layTenKichCo(productDetails.maKichCo),
                        ]),
                        builder: (context, mauKichCoSnapshot) {
                          if (mauKichCoSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (mauKichCoSnapshot.hasError) {
                            return Text('Lỗi tải màu sắc hoặc kích cỡ: ${mauKichCoSnapshot.error}');
                          }

                          final tenMau = mauKichCoSnapshot.data![0];
                          final tenKichCo = mauKichCoSnapshot.data![1];

                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Image.network(
                                    storageService.getImageUrl(productDetails.maHinhAnh),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              tenSPSnapshot.data ?? 'Tên sản phẩm không tìm thấy',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min, // Takes minimum horizontal space needed
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'SL: ',
                                                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${chiTiet.soLuong}',
                                                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        _buildInfoRow('Kích cỡ', tenKichCo),
                                        _buildInfoRow('Màu sắc', tenMau),
                                        _buildInfoRow('Đơn giá', '${sharedFunction.formatCurrency( chiTiet.donGia)}'),
                                        _buildInfoRow('Thành tiền', '${sharedFunction.formatCurrency(chiTiet.donGia * chiTiet.soLuong)}'),
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
