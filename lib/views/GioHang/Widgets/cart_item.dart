import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietGioHang.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.item,
    required this.maKH,
    required this.imageUrl,
    required this.onDelete,
    required this.onDecrease,
    required this.onIncreate,
  });
  final ChiTietGioHang item;
  final String maKH;
  final String imageUrl;
  final Future<void> Function() onDelete;
  final Future<void> Function() onDecrease;
  final Future<void> Function() onIncreate;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final ChiTietSPController _chiTietSPController = ChiTietSPController();
  final SanPhamController sanPhamController = SanPhamController();
  late ChiTietSP ctsp;
  SanPham? sanpham;

  initData() async {
    ctsp = await _chiTietSPController.layCTSPTheoMa(widget.item.maCTSP);
    sanpham = await sanPhamController.getProductByMaSP(ctsp.maSP);
    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Hiển thị hình ảnh sản phẩm
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChiTietSanPhamScreen(
                      maSP: ctsp.maSP,
                      maKH: widget.maKH,
                    ),
                  ),
                );
              },
              child: Image.network(
                widget.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 80,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sanpham?.tenSP ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Giá: \$${widget.item.donGia.toStringAsFixed(2)}'),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: widget.onDecrease,
                    ),
                    Text(
                      widget.item.soLuong.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: widget.onIncreate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
