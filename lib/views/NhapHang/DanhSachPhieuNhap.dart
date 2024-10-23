import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/PhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/TaoPhieuNhap.dart';
import 'package:flutter/material.dart';

import '../../models/ChiTietPhieuNhap.dart';
import '../../services/shared_function.dart';
import 'ChiTietPhieuNhap.dart';
import 'OrderItem.dart';



class PurchaseOrderList extends StatefulWidget {
  final PhieuNhapController phieuNhapController = PhieuNhapController();
  final ChiTietPhieuNhapController chiTietPhieuNhapController = ChiTietPhieuNhapController();
  final String maNV;

  PurchaseOrderList({Key? key, required this.maNV}) : super(key: key);
  @override
  _PurchaseOrderListState createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends State<PurchaseOrderList> {
  late Future<List<PhieuNhap>> futurePhieuNhaps;

  @override
  void initState() {
    super.initState();
    // Load the data when the widget is initialized
    futurePhieuNhaps = PhieuNhapController().layDanhSachPhieuNhap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách phiếu nhập', style: TextStyle(fontFamily: 'Comfortaa')),
        backgroundColor: Color(0xFF034EA2),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<PhieuNhap>>(
        future: futurePhieuNhaps,
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
                future: ChiTietPhieuNhapController().layDanhSachChiTietPhieuNhap(phieuNhap.maPhieuNhap),
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
                        itemCount: 0,
                        totalAmount: 0,
                      ),
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
                      ).then((result) {
                        // Check if data has changed
                        if (result == true) {
                          setState(() {
                            futurePhieuNhaps = widget.phieuNhapController.layDanhSachPhieuNhap();
                          });
                        }
                      });
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
          String newOrderCode = await PhieuNhapController().generateOrderCode();
          // Now you can pass newOrderCode to the InventoryEntryScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InventoryEntryScreen(newOrderCode: newOrderCode, maNV: widget.maNV),
            ),
          ).then((result) {
            if (result == true) {
              // Reload the data when returning from the InventoryEntryScreen
              setState(() {
                futurePhieuNhaps = PhieuNhapController().layDanhSachPhieuNhap();
              });
            }
          });
        },
      ),
    );
  }
}


