import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/DanhSachPhieuNhap.dart';
import 'package:flutter/material.dart';

import '../../models/ChiTietPhieuNhap.dart';
import '../../models/ChiTietSP.dart';
import '../../models/PhieuNhap.dart';

class InventoryForm extends StatelessWidget {
  final PhieuNhap phieuNhap;
  final List<Map<String, dynamic>> selectedProductsWithQuantities;
  final ChiTietPhieuNhapController _controller = ChiTietPhieuNhapController();

  InventoryForm({
    Key? key,
    required this.phieuNhap,
    required this.selectedProductsWithQuantities,
  }) : super(key: key);

  Future<void> _saveInventoryDetails(BuildContext context) async {
    try {
      // Convert selected products to ChiTietPhieuNhap objects
      List<ChiTietPhieuNhap> chiTietPhieuNhaps = selectedProductsWithQuantities.map((productData) {
        final ChiTietSP product = productData['product'];
        final int quantity = productData['quantity'];

        return ChiTietPhieuNhap(
          maPN: phieuNhap.maPhieuNhap,
          maCTSP: product.maCTSP,
          soLuong: quantity,
          donGia: product.giaBan,
        );
      }).toList();


      final savedDetails = await _controller.themNhieuChiTietPhieuNhap(chiTietPhieuNhaps);

      if (savedDetails.length == chiTietPhieuNhaps.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lưu phiếu nhập thành công")),
        );
        Navigator.push(context,MaterialPageRoute(builder:(context)=> PurchaseOrderList(maNV:phieuNhap.maNV)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Một số mục không được lưu thành công"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lưu phiếu nhập thất bại: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết phiếu nhập'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin chi tiết', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildInfoField('Mã phiếu nhập', phieuNhap.maPhieuNhap),
            _buildInfoField('Nhà cung cấp', phieuNhap.nhaCungCap),
            _buildInfoField('Ngày đặt', phieuNhap.ngayDat.toString()),
            _buildInfoField('Mã nhân viên', phieuNhap.maNV),
            SizedBox(height: 24),
            Text('Chi tiết phiếu nhập', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildProductList(),
            SizedBox(height: 8),
            Text(
              'Tổng tiền: ${phieuNhap.tongTien.toStringAsFixed(0)}đ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()=> _saveInventoryDetails(context),
                child: Text('Lưu phiếu nhập'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: selectedProductsWithQuantities.length,
        itemBuilder: (context, index) {
          final productData = selectedProductsWithQuantities[index];
          final ChiTietSP product = productData['product'];
          final int quantity = productData['quantity'];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.maSP, style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Mã: ${product.maCTSP}, Màu: ${product.maMau}, Kích cỡ: ${product.maKichCo}'),
                Text('Đơn giá: ${product.giaBan}, Số lượng: $quantity'),
                if (index < selectedProductsWithQuantities.length - 1) Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}