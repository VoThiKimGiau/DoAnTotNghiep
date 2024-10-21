import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/SanPham.dart';
import '../services/storage/storage_service.dart';

class SanPhamItem extends StatelessWidget {
  final SanPham item;
  SanPhamItem({required this.item});

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
              child: Column(
            children: [
              ClipRRect(
                child: Image.network(
              service.getImageUrl(item.hinhAnhMacDinh),
                  fit: BoxFit.cover,
                  width: 160,
                  height: 200,
                ),
              ),
              SizedBox(
                height: 45,
                child: Text(
                  item.tenSP,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 15,
                child: Text(
                  sharedFunction.formatCurrency(item.giaMacDinh),
                  textAlign: TextAlign.left,
                  style:
                      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Gabarito'),
                ),
              ),
            ],
          )),
          Container(
            child: ElevatedButton(
                onPressed: () {
                  print('a');
                },
                child: SvgPicture.asset(
                  'assets/icons/heart.svg',
                  width: 16,
                  height: 16,
                )),
          )
        ],
      ),
    );
  }
}
