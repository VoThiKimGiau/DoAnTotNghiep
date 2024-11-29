import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/views/DoiTra/ImageUploadScreen.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DonHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/HinhAnhController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KMDHController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietDonHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietDonHang.dart';
import 'package:datn_cntt304_bandogiadung/models/KMDH.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';

import '../../dto/ChiTietDoiTraDTO.dart';
import '../../dto/ChiTietDonHangDTO.dart';
import '../../dto/DoiTraDTO.dart';
import '../../models/ChiTietDoiTra.dart';

class Danhsachsanphamdoitra extends StatefulWidget {
  final DonHang donHang;

  const Danhsachsanphamdoitra({Key? key, required this.donHang}) : super(key: key);

  @override
  _DanhsachsanphamdoitraState createState() => _DanhsachsanphamdoitraState();
}

class _DanhsachsanphamdoitraState extends State<Danhsachsanphamdoitra> {
  final SanPhamController _sanPhamController = SanPhamController();
  final MauSPController _mauSPController = MauSPController();
  final KichCoController _kichCoController = KichCoController();
  final ChiTietSPController _chiTietSPController = ChiTietSPController();
  final HinhAnhController _hinhAnhController = HinhAnhController();
  final StorageService _storageService = StorageService();
  SharedFunction sharedFunction=SharedFunction();
  Map<String, List<String>> cachedProductDetails = {};
  List<ChiTietDonHangDTO> orderDetailsList = [];
  Map<String, bool> selectedProducts = {};
  double totalRefundAmount = 0.0;
  Map<String, int> productQuantities = {};
  List<ChiTietDoiTra> chiTietDoiTraList = [];

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    try {
      orderDetailsList = await ChiTietDonHangController().fetchListProduct(widget.donHang.maDH);
      for (var item in orderDetailsList) {
        // Load and cache product details for each order item
        cachedProductDetails[item.mactsp] = await _fetchProductDetails(item.mactsp);
      }
      setState(() {});
    } catch (e) {
      print('Error loading order details: $e');
    }
  }

  Future<List<String>> _fetchProductDetails(String maCTSP) async {
    final chiTietSP = await _chiTietSPController.layCTSPTheoMa(maCTSP);
    final String productName = await _sanPhamController.getProductNameByMaSP(chiTietSP.maSP) ?? 'Unknown Product';
    final String productColor = await _mauSPController.layTenMauByMaMau(chiTietSP.maMau) ?? 'Unknown Color';
    final String productSize = await _kichCoController.layTenKichCo(chiTietSP.maKichCo) ?? 'Unknown Size';
    final String productImageUrl = await _storageService.getImageUrl(chiTietSP.maHinhAnh ?? '');

    return [productName, productColor, productSize, productImageUrl];
  }

  void updateTotalRefundAmount() {
    double total = 0.0;
    for (var item in orderDetailsList) {
      if (selectedProducts[item.mactsp] == true) {
        int quantity = productQuantities[item.mactsp] ?? 1;
        total += item.donGia * quantity;
      }
    }
    setState(() {
      totalRefundAmount = total;
    });
  }

  void incrementQuantity(String maCTSP) {
    int currentQuantity = productQuantities[maCTSP] ?? 0;
    int maxQuantity = orderDetailsList.firstWhere((item) => item.mactsp == maCTSP).soLuong;
    if (currentQuantity < maxQuantity) {
      setState(() {
        productQuantities[maCTSP] = currentQuantity + 1;
        updateTotalRefundAmount();
      });
    }
  }

  void decrementQuantity(String maCTSP) {
    int currentQuantity = productQuantities[maCTSP] ?? 0;
    if (currentQuantity > 1) {
      setState(() {
        productQuantities[maCTSP] = currentQuantity - 1;
        updateTotalRefundAmount();
      });
    } else if (currentQuantity == 1) {
      setState(() {
        productQuantities[maCTSP] = 0;
        selectedProducts[maCTSP] = false;
        updateTotalRefundAmount();
      });
    }
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
          'Đơn hàng #${widget.donHang.maDH}',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: orderDetailsList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                children: orderDetailsList.map((item) {
                  final productDetails = cachedProductDetails[item.mactsp] ?? ['', '', '', ''];
                  return _buildProductRow(
                    item.mactsp,
                    productDetails,
                    'SL ${item.soLuong}',
                    '${sharedFunction.formatCurrency(item.donGia)}',
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Tổng số tiền hoàn trả: ${sharedFunction.formatCurrency(totalRefundAmount)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
            child: Text('Tiếp theo'),
            onPressed: totalRefundAmount > 0
            ? () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MultiImageCaptureAndUpload(doiTraDTO: buildDoiTraDTO(), donHang: widget.donHang,)
                ,)
                ,);
            }
                : null,
            ),

          ],
        ),
      ),
    );
  }
  DoiTraDTO buildDoiTraDTO() {
    double totalRefundAmount = 0.0;
    List<ChiTietDoiTraDTO> selectedProductsDetails = [];

    selectedProducts.forEach((maCTSP, isSelected) {
      if (isSelected) {
        final quantity = productQuantities[maCTSP] ?? 1;
        final price = orderDetailsList.firstWhere((item) => item.mactsp == maCTSP).donGia;

        totalRefundAmount += price * quantity;

        selectedProductsDetails.add(ChiTietDoiTraDTO(
          maCTSP: maCTSP,
          gia: price,
          soLuong: quantity,
        ));
      }
    });

    return DoiTraDTO(tongTien: totalRefundAmount, chiTietDoiTras: selectedProductsDetails);
  }



  Widget _buildProductRow(String maCTSP, List<String> productDetails, String quantity, String price) {
    String productName = productDetails[0];
    String productColor = productDetails[1];
    String productSize = productDetails[2];
    String productImageUrl = productDetails[3];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: selectedProducts[maCTSP] ?? false,
            onChanged: (bool? value) {
              setState(() {
                selectedProducts[maCTSP] = value ?? false;
                if (value == true && (productQuantities[maCTSP] ?? 0) == 0) {
                  productQuantities[maCTSP] = 1;
                }
                updateTotalRefundAmount();
              });
            },
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: productImageUrl.isNotEmpty
                ? Image.network(
              productImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, size: 30),
              ),
            )
                : Container(
              color: Colors.grey[200],
              child: Icon(Icons.image_not_supported, size: 30),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '${(productSize)} - $productColor',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: selectedProducts[maCTSP] == true
                          ? () => decrementQuantity(maCTSP)
                          : null,
                      child: Icon(Icons.remove, size: 18),
                    ),
                    SizedBox(width: 8),
                    Text('${productQuantities[maCTSP] ?? 0}', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: selectedProducts[maCTSP] == true
                          ? () => incrementQuantity(maCTSP)
                          : null,
                      child: Icon(Icons.add, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            price,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
