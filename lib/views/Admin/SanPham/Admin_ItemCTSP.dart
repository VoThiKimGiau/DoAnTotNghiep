import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_SuaCTSP.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_SuaSP.dart';
import 'package:flutter/material.dart';

import '../../../colors/color.dart';
import '../../../services/shared_function.dart';
import '../../../services/storage/storage_service.dart';

class ItemCTSP_Admin extends StatefulWidget {
  final ChiTietSP product;
  final VoidCallback onUpdate;

  ItemCTSP_Admin({Key? key, required this.product, required this.onUpdate})
      : super(key: key);

  @override
  _ItemCTSP_AdminState createState() => _ItemCTSP_AdminState();
}

class _ItemCTSP_AdminState extends State<ItemCTSP_Admin> {
  StorageService storageService = StorageService();
  SharedFunction sharedFunction = SharedFunction();
  KichCoController kichCoController = KichCoController();
  MauSPController mauSPController = MauSPController();

  String tenMau = '';
  String tenKC = '';

  @override
  void initState() {
    super.initState();
    getTen();
  }

  Future<void> getTen() async {
    String fetchMau =
        await mauSPController.layTenMauByMaMau(widget.product.maMau);
    String fetchKC =
        await kichCoController.layTenKichCo(widget.product.maKichCo);

    setState(() {
      tenMau = fetchMau;
      tenKC = fetchKC;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Image.network(
              storageService.getImageUrl(widget.product.maHinhAnh),
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$tenKC - $tenMau',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    sharedFunction.formatCurrency(widget.product.giaBan),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminSuaCTSPScreen(
                          maCTSP: widget.product.maCTSP,
                          maSP: widget.product.maSP)),
                );

                if (result) {
                  widget.onUpdate();
                }
              },
              child: const Text(
                'Sửa',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
