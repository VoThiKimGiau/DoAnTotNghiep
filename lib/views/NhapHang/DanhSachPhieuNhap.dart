import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/PhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/TaoPhieuNhap.dart';
import 'package:flutter/material.dart';

import '../../models/ChiTietPhieuNhap.dart';
import '../../services/shared_function.dart';
import 'ChiTietPhieuNhap.dart';



class PurchaseOrderList extends StatelessWidget {
  final PhieuNhapController phieuNhapController = PhieuNhapController();
  final ChiTietPhieuNhapController chiTietPhieuNhapController = ChiTietPhieuNhapController();
  final String? maNV;

  PurchaseOrderList({Key? key, required this.maNV}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách phiếu nhập',style: TextStyle(fontFamily: 'Comfortaa')),
        backgroundColor: Color(0xFF034EA2),
        centerTitle: true,
        automaticallyImplyLeading: false,

      ),
      body: FutureBuilder<List<PhieuNhap>>(
        future: phieuNhapController.layDanhSachPhieuNhap(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có phiếu nhập nào.'));
          }

          List<PhieuNhap> phieuNhaps = snapshot.data!;

          return ListView.builder(
            itemCount: phieuNhaps.length,
            itemBuilder: (context, index) {
              PhieuNhap phieuNhap = phieuNhaps[index];
              return FutureBuilder<List<ChiTietPhieuNhap>>(
                future: chiTietPhieuNhapController.layDanhSachChiTietPhieuNhap(phieuNhap.maPhieuNhap),
                builder: (context, detailSnapshot) {
                  if (detailSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Đang tải chi tiết...'),
                    );
                  } else if (detailSnapshot.hasError) {
                    return ListTile(
                      title: Text('Có lỗi xảy ra: ${detailSnapshot.error}'),
                    );
                  } else if (!detailSnapshot.hasData || detailSnapshot.data!.isEmpty) {
                    return ListTile(
                      title: Text('Chi tiết không có sẵn.'),
                    );
                  }

                  List<ChiTietPhieuNhap> chiTietPhieuNhaps = detailSnapshot.data!;
                  int totalQuantity = chiTietPhieuNhaps.length;
                  double totalAmount = chiTietPhieuNhaps.fold(0, (sum, item) => sum + (item.donGia * item.soLuong));

                  return GestureDetector(
                    onTap: () {
                      // Navigate to OrderStatusScreen and pass the order number
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderStatusScreen(pn: phieuNhap),
                        ),
                      );
                    },
                    child: OrderItem(
                      orderNumber: phieuNhap.maPhieuNhap,
                      itemCount: totalQuantity,
                      totalAmount: totalAmount,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          String newOrderCode = await phieuNhapController.generateOrderCode();
          // Now you can pass newOrderCode to the InventoryEntryScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InventoryEntryScreen(newOrderCode: newOrderCode),
            ),
          );
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String orderNumber;
  final int itemCount;
  final double totalAmount;

  const OrderItem({
    Key? key,
    required this.orderNumber,
    required this.itemCount,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.grey,size: 22),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mã phiếu: $orderNumber',
                  style: TextStyle(fontSize: 20,fontFamily: 'Comfortaa'),
                ),
                Text('Số lượng chi tiết: $itemCount', style: TextStyle(fontSize:18,color: Colors.grey,fontFamily: 'Comfortaa')),
                Text('Tổng tiền: ${totalAmount.toStringAsFixed(0)} VNĐ', style: TextStyle(fontSize:18,color: Colors.grey,fontFamily: 'Comfortaa')),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
