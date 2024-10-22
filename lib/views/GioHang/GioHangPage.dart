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
  double _tinhTongTien() {
    double tongTien = 0.0;
    for (var item in widget.gioHangItems) {
      tongTien += item.donGia * item.soLuong;
    }
    return tongTien;
  }

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

  void _datHang() {
    double tongTien = _tinhTongTien();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutPage(totalAmount: tongTien),
      ),
    );
  }

  void _troVeTrangChu() {
    Navigator.of(context).pop();
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'Orange':
        return Colors.orange;
      case 'Black':
        return Colors.black;
      case 'Red':
        return Colors.red;
      default:
        return Colors.grey; // Giá trị mặc định
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.gioHangItems.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Giỏ hàng trống',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _troVeTrangChu,
                child: Text('Trở về trang chủ', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sản phẩm đã chọn:', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.gioHangItems.length,
                itemBuilder: (context, index) {
                  final item = widget.gioHangItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Màu sắc: ${item.maMau}', style: TextStyle(fontSize: 18)),
                              SizedBox(width: 10),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _getColorFromName(item.maMau), // Lấy màu sắc tương ứng
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          Text('Kích cỡ: ${item.maKichCo}', style: TextStyle(fontSize: 18)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                  Text(item.soLuong.toString(), style: TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      _capNhatSoLuong(index, item.soLuong + 1);
                                    },
                                  ),
                                ],
                              ),
                              Text('Giá: \$${(item.donGia * item.soLuong).toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    widget.gioHangItems.removeAt(index);
                                  });
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
            Text(
              'Tổng tiền: \$${_tinhTongTien().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _datHang,
              child: Text('Đặt hàng', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
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
