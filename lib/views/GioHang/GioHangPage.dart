import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/models/GioHang.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/Widgets/cart_item.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/ChiTietGioHangController.dart';
import '../../models/ChiTietGioHang.dart';
import '../../services/shared_function.dart';
import '../../services/storage/storage_service.dart';
import 'CheckoutPage.dart';

class GioHangPage extends StatefulWidget {
  final String maGioHang;
  final String? maKH;

  GioHangPage({required this.maGioHang, required this.maKH});

  @override
  _GioHangPageState createState() => _GioHangPageState();
}

class _GioHangPageState extends State<GioHangPage> {
  ChiTietGioHangController _controller = ChiTietGioHangController();
  List<ChiTietGioHang> gioHangItems = [];
  List<bool> selectedItems = [];

  bool _isLoading = true;
  bool _hasFetchedItems = false;

  ChiTietSPController _chiTietSPController = ChiTietSPController();
  List<ChiTietSP> ctspItems = [];
  int soLuong = 1;

  SharedFunction sharedFunction = SharedFunction();
  bool selectAll = false;

  double tongTien = 0;
  List<int> dsSLMua = [];

  @override
  void initState() {
    super.initState();
    _fetchGioHangItems();
  }

  Future<void> _fetchGioHangItems() async {
    try {
      final items = await _controller.fetchListProduct(widget.maGioHang);
      setState(() {
        gioHangItems = items;
        selectedItems = List.generate(gioHangItems.length, (index) => false);
        dsSLMua = List.generate(
            gioHangItems.length, (index) => gioHangItems[index].soLuong);
        _isLoading = false;
        _hasFetchedItems = true;
        fetchCTSP();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasFetchedItems = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  Future<void> fetchCTSP() async {
    try {
      List<ChiTietSP> fetchItems = [];
      for (ChiTietGioHang gh in gioHangItems) {
        ChiTietSP item = await _chiTietSPController.layCTSPTheoMa(gh.maCTSP);
        fetchItems.add(item);
      }

      setState(() {
        ctspItems = fetchItems;
      });
    } catch (e) {
      setState(() {
        ctspItems = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  double _tinhTongTien() {
    double tongTien = 0.0;
    for (int i = 0; i < gioHangItems.length; i++) {
      if (selectedItems[i]) {
        tongTien += gioHangItems[i].donGia * gioHangItems[i].soLuong;
      }
    }
    return tongTien;
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      dsSLMua[index] = newQuantity;
      _controller.capnhatChiTietGioHang(new ChiTietGioHang(
          maGioHang: gioHangItems[index].maGioHang,
          maCTSP: gioHangItems[index].maCTSP,
          soLuong: newQuantity,
          donGia: gioHangItems[index].donGia));
      tongTien = _tinhTongTien();
    });
  }

  Future<void> _datHang() async {
    if (!selectedItems.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng chọn ít nhất một sản phẩm để đặt hàng.')),
      );
      return; // Abort the order process
    }

    List<ChiTietSP> selectedProducts = [];
    for (int i = 0; i < ctspItems.length; i++) {
      if (selectedItems[i]) {
        selectedProducts.add(ctspItems[i]);
      }
    }

    List<int> selectedQuantities = [];
    for (int i = 0; i < gioHangItems.length; i++) {
      if (selectedItems[i]) {
        selectedQuantities.add(dsSLMua[i]);
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          dsSP: selectedProducts,
          customerId: widget.maKH,
          slMua: selectedQuantities,
          maGH: widget.maGioHang, muaTu: 'Giỏ hàng',

        ),
      ),
    );
  }

  void _xoaTatCa() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text(
              'Bạn có chắc chắn muốn xóa tất cả sản phẩm trong giỏ hàng không?'),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _controller.xoaTatCaGioHang(widget.maGioHang);
      _fetchGioHangItems();
      setState(() {});
    }
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      selectedItems = List.generate(gioHangItems.length, (index) => selectAll);
      tongTien = _tinhTongTien();
    });
  }

  void _updateSelectStatus(int index, bool? value) {
    setState(() {
      selectedItems[index] = value ?? false;
      selectAll = selectedItems.every((selected) => selected);
      tongTien = _tinhTongTien();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
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
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : !_hasFetchedItems
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
                          Row(
                            children: [
                              Checkbox(
                                value: selectAll,
                                onChanged: _toggleSelectAll,
                                checkColor: Colors.white,
                                activeColor: AppColors.primaryColor,
                              ),
                              const Text(
                                'Chọn tất cả',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: ctspItems.length,
                              itemBuilder: (context, index) {
                                final item = ctspItems[index];
                                soLuong = gioHangItems[index].soLuong;

                                return CartItem(
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
                                  onCheckboxChanged: (bool? value) {
                                    _updateSelectStatus(index, value);
                                  },
                                  isSelected: selectedItems[index],
                                  soLuongTr: soLuong,
                                  onQuantityChanged: (int newQuantity) {
                                    _updateQuantity(index, newQuantity);
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                sharedFunction.formatCurrency(tongTien),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gabarito',
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _datHang,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            child: const Text(
                              'Đặt hàng',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}
