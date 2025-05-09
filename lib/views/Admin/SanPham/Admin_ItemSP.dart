import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_SuaSP.dart';
import 'package:flutter/material.dart';

import '../../../colors/color.dart';
import '../../../models/SanPham.dart';
import '../../../services/shared_function.dart';
import '../../../services/storage/storage_service.dart';

class ItemSP_Admin extends StatelessWidget {
  final SanPham product;

  ItemSP_Admin({Key? key, required this.product}) : super(key: key);

  StorageService storageService = StorageService();
  SharedFunction sharedFunction = SharedFunction();

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
              storageService.getImageUrl(product.hinhAnhMacDinh),
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
                    product.tenSP,
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
                    sharedFunction.formatCurrency(product.giaMacDinh),
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AdminSuaSPScreen(maSP: product.maSP)));
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
