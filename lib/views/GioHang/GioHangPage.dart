import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/Widgets/cart_item.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  ChiTietSPController _chiTietSPController = ChiTietSPController();

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
        builder: (context) => CheckoutPage(
          totalAmount: tongTien,
          customerId: widget.maKH,
        ),
      ),
    );
  }

  // Hàm xóa toàn bộ giỏ hàng
  void _xoaTatCa() async {
    await _controller.xoaTatCaGioHang(widget.maGioHang);
    _fetchGioHangItems();
    setState(() {});
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
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (gioHangItems.isNotEmpty)
            TextButton(
              onPressed: _xoaTatCa,
              child: const Text(
                'Xoá tất cả',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : gioHangItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/badge.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Giỏ hàng trống',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Trở về trang chủ'),
                        ),
                      ],
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
                            final imageUrl =
                                _storageService.getImageUrl(item.maCTSP);

                            return CartItem(
                              imageUrl: imageUrl,
                              item: item,
                              maKH: widget.maKH!,
                              onDelete: () async {
                                await _controller.xoaChiTietGioHang(
                                  widget.maGioHang,
                                  item.maCTSP,
                                );
                                await _fetchGioHangItems();
                                setState(() {});
                              },
                              onDecrease: () async {
                                if (item.soLuong > 1) {
                                  await _controller.capnhatChiTietGioHang(
                                    item.copyWith(
                                      soLuong: item.soLuong - 1,
                                    ),
                                  );
                                  await _fetchGioHangItems();
                                  setState(() {});
                                }
                              },
                              onIncreate: () async {
                                await _controller.capnhatChiTietGioHang(
                                  item.copyWith(
                                    soLuong: item.soLuong + 1,
                                  ),
                                );
                                await _fetchGioHangItems();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng cộng:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${_tinhTongTien().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _datHang,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Đặt hàng',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
