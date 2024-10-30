import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/PhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/ChiTietPhieuNhap.dart';
import '../../services/shared_function.dart';
import 'ChiTietPhieuNhap.dart';
import 'FilterDrawer.dart';
import 'OrderItem.dart';
import 'TaoPhieuNhap.dart';

class PurchaseOrderList extends StatefulWidget {
  final ChiTietPhieuNhapController chiTietPhieuNhapController = ChiTietPhieuNhapController();
  final String maNV;

  PurchaseOrderList({Key? key, required this.maNV}) : super(key: key);
  @override
  _PurchaseOrderListState createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends State<PurchaseOrderList> {
  late Future<List<PhieuNhap>> futurePhieuNhaps;
  List<PhieuNhap> phieuNhaps = [];
  String? statusFilter;
  DateTime? startDate;
  DateTime? endDate;
  final PhieuNhapController phieuNhapController = PhieuNhapController();

  @override
  void initState() {
    super.initState();
    // Load the data when the widget is initialized
    futurePhieuNhaps = _loadPhieuNhaps();
  }

  Future<List<PhieuNhap>> _loadPhieuNhaps() async {
    try {
      List<PhieuNhap> result;

      // Apply filters
      if (statusFilter != null && startDate != null && endDate != null) {
        String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);

        // Lấy tất cả phiếu nhập theo trạng thái
        result =
        await phieuNhapController.getPhieuNhapByTrangThai(statusFilter!);

        // Sau đó, lọc theo khoảng thời gian
        result = result.where((phieuNhap) {
          try {
            // Giả sử `ngayDat` là chuỗi có định dạng ngày
            DateTime date = phieuNhap
                .ngayDat; // Chuyển đổi `ngayDat` sang `DateTime`

            // Kiểm tra xem ngày nằm trong khoảng không
            return date.isAfter(startDate!.subtract(Duration(days: 1))) &&
                date.isBefore(endDate!.add(Duration(days: 1)));
          } catch (e) {
            print('Error parsing date for PhieuNhap: ${phieuNhap
                .maPhieuNhap}, error: $e');
            return false; // Nếu có lỗi, bỏ qua phiếu nhập này
          }
        }).toList();
      }
      else if (statusFilter != null) {
        result =
        await phieuNhapController.getPhieuNhapByTrangThai(statusFilter!);
      } else if (startDate != null && endDate != null) {
        String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);
        result = await phieuNhapController.filterPhieuNhapBetweenDates(
            formattedStartDate, formattedEndDate);
      } else {
        result = await phieuNhapController.layDanhSachPhieuNhap();
      }

      return result;
    } catch (e) {
      print('Error loading phieu nhaps: $e');
      throw e; // Rethrow error to be caught in FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách phiếu nhập'),
        actions: [
          Builder(
            builder: (context) =>
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
      ),
      endDrawer: FilterDrawer(
        onStatusFilterChanged: (String? status) {
          setState(() {
            statusFilter = status;
            futurePhieuNhaps = _loadPhieuNhaps();
          });
          _loadPhieuNhaps();
        },
        onDateFilterChanged: (DateTime? start, DateTime? end) {
          setState(() {
            startDate = start;
            endDate = end;
            futurePhieuNhaps = _loadPhieuNhaps();
          });
          _loadPhieuNhaps();
        },
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
          double totalThanhTien = phieuNhaps.fold(
              0, (sum, phieuNhap) => sum + phieuNhap.tongTien);

          return Column(
            children: [
              // Display total ThanhTien in a Container
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.blueAccent,
                child: Text(
                  'Tổng Thanh Tiền: ${NumberFormat.currency(
                      locale: 'vi', symbol: '₫').format(totalThanhTien)}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              // ListView to display the PhieuNhap items
              Expanded(
                child: ListView.builder(
                  itemCount: phieuNhaps.length,
                  itemBuilder: (context, index) {
                    PhieuNhap phieuNhap = phieuNhaps[index];
                    return FutureBuilder<List<ChiTietPhieuNhap>>(
                      future: ChiTietPhieuNhapController()
                          .layDanhSachChiTietPhieuNhap(phieuNhap.maPhieuNhap),
                      builder: (context, detailSnapshot) {
                        if (detailSnapshot.connectionState == ConnectionState
                            .waiting) {
                          return ListTile(
                            title: Text('Đang tải chi tiết...'),
                          );
                        } else if (detailSnapshot.hasError) {
                          return ListTile(
                            title: Text(
                                'Có lỗi xảy ra: ${detailSnapshot.error}'),
                          );
                        } else if (!detailSnapshot.hasData ||
                            detailSnapshot.data!.isEmpty) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderStatusScreen(pn: phieuNhap),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  setState(() {
                                    futurePhieuNhaps = _loadPhieuNhaps();
                                  });
                                }
                              });
                            },
                            child: OrderItem(
                              orderNumber: phieuNhap.maPhieuNhap,
                              itemCount: 0,
                              totalAmount: 0,
                            ),
                          );
                        }

                        List<
                            ChiTietPhieuNhap> chiTietPhieuNhaps = detailSnapshot
                            .data!;
                        int totalQuantity = chiTietPhieuNhaps.length;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderStatusScreen(pn: phieuNhap),
                              ),
                            ).then((result) {
                              if (result == true) {
                                setState(() {
                                  futurePhieuNhaps = _loadPhieuNhaps();
                                });
                              }
                            });
                          },
                          child: OrderItem(
                            orderNumber: phieuNhap.maPhieuNhap,
                            itemCount: totalQuantity,
                            totalAmount: phieuNhap.tongTien, // Use ThanhTien directly
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          String newOrderCode = await PhieuNhapController().generateOrderCode();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InventoryEntryScreen(
                      newOrderCode: newOrderCode, maNV: widget.maNV),
            ),
          ).then((result) {
            if (result == true) {
              setState(() {
                futurePhieuNhaps = _loadPhieuNhaps();
              });
            }
          });
        },
      ),
    );
  }
}
