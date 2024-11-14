import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/SanPham.dart';
import '../services/storage/storage_service.dart';

class SanPhamItem extends StatelessWidget {
  final SanPham item;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  SanPhamItem({required this.item, required this.isFavorite,required this.onFavoriteToggle,});

  StorageService service = StorageService();
  SharedFunction sharedFunction = SharedFunction();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      height: 250,
      width: 160,
      child: Stack(
        children: [
          Card(
              color: Colors.white,
              child: Column(
                children: [
                  ClipRRect(
                    child: Image.network(
                      service.getImageUrl(item.hinhAnhMacDinh),
                      fit: BoxFit.cover,
                      width: 160,
                      height: 190,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 45,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.tenSP,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.black),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 10, bottom: 12),
                    height: 15,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sharedFunction.formatCurrency(item.giaMacDinh),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gabarito'),
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
              top: 1,
              right: 1,
              child: ElevatedButton(
                onPressed: onFavoriteToggle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(18, 18),
                  padding: const EdgeInsets.all(0),
                ),
                child: SvgPicture.asset(
                  isFavorite ? 'assets/icons/heart_red.svg' : 'assets/icons/heart.svg',
                  width: 16,
                  height: 16,
                ),
              ))
        ],
      ),
    );
  }
}
