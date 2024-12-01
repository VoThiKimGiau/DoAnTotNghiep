import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietGioHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietGioHang.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:flutter/material.dart';
import '../../../controllers/KichCoController.dart';
import '../../../controllers/MauSPController.dart';
import '../../../services/storage/storage_service.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.item,
    required this.maKH,
    required this.soLuongTr,
    required this.onDelete,
    required this.onCheckboxChanged,
    required this.isSelected,
    required this.onQuantityChanged,
  });

  final ChiTietSP item;
  final String maKH;
  final int soLuongTr;
  final Future<void> Function() onDelete;
  final ValueChanged<bool?> onCheckboxChanged;
  final bool isSelected;
  final ValueChanged<int> onQuantityChanged;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final ChiTietSPController _chiTietSPController = ChiTietSPController();
  final SanPhamController sanPhamController = SanPhamController();
  MauSPController mauSPController = MauSPController();
  KichCoController kichCoController = KichCoController();

  StorageService _storageService = StorageService();
  SharedFunction sharedFunction = SharedFunction();

  String? tenMau;
  String? tenKC;
  SanPham? sanpham;

  int soLuong = 1;

  initData() async {
    sanpham = await sanPhamController.getProductByMaSP(widget.item.maSP);
    soLuong = widget.soLuongTr;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData();
    layTenMau(widget.item.maMau);
    layTenKichCo(widget.item.maKichCo);
  }

  Future<void> layTenMau(String maMau) async {
    try {
      String fetchItem = await mauSPController.layTenMauByMaMau(maMau);
      setState(() {
        tenMau = fetchItem;
      });
    } catch (error) {
      setState(() {
        tenMau = null;
      });
    }
  }

  Future<void> layTenKichCo(String maKichCo) async {
    try {
      String fetchItem = await kichCoController.layTenKichCo(maKichCo);
      setState(() {
        tenKC = fetchItem;
      });
    } catch (error) {
      setState(() {
        tenKC = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Change the state of the checkbox
                bool newValue = !widget.isSelected;
                widget.onCheckboxChanged(newValue); // Call the callback
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? AppColors.primaryColor
                      : const Color(0xFFdcdcdc),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: widget.isSelected
                      ? const Icon(Icons.check_circle, color: Colors.white)
                      : const Icon(Icons.check_circle_outline,
                          color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChiTietSanPhamScreen(
                      maSP: widget.item.maSP,
                      maKH: widget.maKH,
                    ),
                  ),
                );
              },
              child: Image.network(
                _storageService.getImageUrl(widget.item.maHinhAnh),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sanpham?.tenSP ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(tenMau ?? '', style: const TextStyle(fontSize: 12,
                    fontFamily: 'Gabarito',),),
                  const SizedBox(height: 4),
                  Text(tenKC ?? '', style: const TextStyle(fontSize: 12,
                    fontFamily: 'Gabarito',),),
                  const SizedBox(height: 4),
                  Text(
                    sharedFunction.formatCurrency(widget.item.giaBan),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, size: 25,),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20,),
                      onPressed: () {
                        if (soLuong > 1) {
                          setState(() {
                            soLuong--;
                            widget.onQuantityChanged(soLuong);
                          });
                        }
                      },
                    ),
                    Text(
                      soLuong.toString(),
                      style: const TextStyle(fontSize: 14,
                        fontFamily: 'Gabarito',),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20,),
                      onPressed: () {
                        if (soLuong < widget.item.slKho) {
                          setState(() {
                            soLuong++;
                            widget.onQuantityChanged(soLuong);
                          });
                        } else if (soLuong == widget.item.slKho) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Hiện tại chỉ còn ${widget.item.slKho} sản phẩm"),
                          ));
                        }
                      },
                    ),
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
