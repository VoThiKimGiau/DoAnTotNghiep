import 'package:flutter/material.dart';
import '../../models/ChiTietGioHang.dart';
import 'CheckoutPage.dart';

class GioHangPage extends StatefulWidget {
  final List<ChiTietGioHang> gioHangItems;

  GioHangPage({required this.gioHangItems});

  @override
  _GioHangPageState createState() => _GioHangPageState();
}

class _GioHangPageState extends State<GioHangPage> {
  // Hàm tính tổng tiền của giỏ hàng
  double _tinhTongTien() {
    double tongTien = 0.0;
    for (var item in widget.gioHangItems) {
      tongTien += item.donGia * item.soLuong;
    }
    return tongTien;
  }

  // Hàm cập nhật số lượng sản phẩm trong giỏ hàng
  void _capNhatSoLuong(int index, int soLuongMoi) {
    setState(() {
      final itemCu = widget.gioHangItems[index];
      widget.gioHangItems[index] = ChiTietGioHang(
        maGioHang: itemCu.maGioHang,
        maSP: itemCu.maSP,
        maKichCo: itemCu.maKichCo,
        maMau: itemCu.maMau,
        soLuong: soLuongMoi,
        donGia: itemCu.donGia,
      );
    });
  }


  // Hàm điều hướng tới trang thanh toán
  void _datHang() {
    double tongTien = _tinhTongTien();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutPage(totalAmount: tongTien),
      ),
    );
  }

  // Hàm xóa toàn bộ giỏ hàng
  void _xoaTatCa() {
    setState(() {
      widget.gioHangItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Giỏ hàng',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _xoaTatCa,
            child: Text('Xoá tất cả', style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.gioHangItems.isEmpty
            ? Center(
          child: Text(
            'Giỏ hàng trống',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.gioHangItems.length,
                itemBuilder: (context, index) {
                  final item = widget.gioHangItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.maSP,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text('Giá: \$${item.donGia.toStringAsFixed(2)}'),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (item.soLuong > 1) {
                                    _capNhatSoLuong(index, item.soLuong - 1);
                                  }
                                },
                              ),
                              Text(item.soLuong.toString(),
                                  style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  _capNhatSoLuong(index, item.soLuong + 1);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng cộng:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('\$${_tinhTongTien().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _datHang,
              child: Text('Đặt hàng', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
