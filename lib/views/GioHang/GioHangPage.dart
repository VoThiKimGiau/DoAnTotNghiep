import 'package:flutter/material.dart';
import '../../controllers/ChiTietGioHangController.dart';
import '../../models/ChiTietGioHang.dart';
import '../../services/storage/storage_service.dart';
import 'CheckoutPage.dart';


class GioHangPage extends StatefulWidget {
  final String maGioHang; // Thêm maGioHang để lấy thông tin giỏ hàng
  final String? maKH;

  GioHangPage({required this.maGioHang, required this.maKH});

  @override
  _GioHangPageState createState() => _GioHangPageState();
}

class _GioHangPageState extends State<GioHangPage> {
  late ChiTietGioHangController _controller;
  late StorageService _storageService;
  List<ChiTietGioHang> gioHangItems = [];
  bool _isLoading = true; // Biến để theo dõi trạng thái tải

  @override
  void initState() {
    super.initState();
    _controller = ChiTietGioHangController();
    _storageService = StorageService(); // Khởi tạo StorageService
    _fetchGioHangItems(); // Gọi hàm để lấy danh sách sản phẩm
  }

  // Hàm lấy danh sách sản phẩm trong giỏ hàng
  Future<void> _fetchGioHangItems() async {
    try {
      final items = await _controller.fetchListProduct(widget.maGioHang);
      setState(() {
        gioHangItems = items;
        _isLoading = false; // Cập nhật trạng thái tải
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Cập nhật trạng thái tải
      });
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  // Hàm tính tổng tiền của giỏ hàng
  double _tinhTongTien() {
    double tongTien = 0.0;
    for (var item in gioHangItems) {
      tongTien += item.donGia * item.soLuong;
    }
    return tongTien;
  }

  // Hàm điều hướng tới trang thanh toán
  void _datHang() {
    double tongTien = _tinhTongTien();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutPage(totalAmount: tongTien, customerId: widget.maKH,),
      ),
    );
  }

  // Hàm xóa toàn bộ giỏ hàng
  void _xoaTatCa() {
    setState(() {
      gioHangItems.clear();
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : gioHangItems.isEmpty
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
                itemCount: gioHangItems.length,
                itemBuilder: (context, index) {
                  final item = gioHangItems[index];
                  final imageUrl = _storageService.getImageUrl(item.maCTSP);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Hiển thị hình ảnh sản phẩm
                          Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 80);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.maCTSP,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text('Giá: \$${item.donGia.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (item.soLuong > 1) {
                                    //_capNhatSoLuong(index, item.soLuong - 1);
                                  }
                                },
                              ),
                              Text(item.soLuong.toString(), style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  //_capNhatSoLuong(index, item.soLuong + 1);
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
