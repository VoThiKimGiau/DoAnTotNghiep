import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/SanPham.dart';
import '../services/storage/storage_service.dart';

class SanPhamItem extends StatelessWidget {
  final SanPham item;
  SanPhamItem({required this.item});

  StorageService service = StorageService();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
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
              Text(
                item.tenSP,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black),
              ),
              Text(
                item.giaMacDinh.toString(),
                textAlign: TextAlign.left,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
