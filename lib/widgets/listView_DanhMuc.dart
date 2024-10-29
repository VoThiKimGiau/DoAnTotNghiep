import 'package:flutter/material.dart';

import '../models/DanhMucSP.dart';
import '../views/DanhMuc/ProductByCategory.dart';

class DanhMucListView extends StatelessWidget {

  final List<DanhMucSP>? items;
  final String? maKH;

  DanhMucListView({this.items, this.maKH});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: items == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: items!.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductByCategoryScreen(
                      maDanhMuc: items![index].maDanhMuc,
                      maKH: maKH,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: Image.network(
                          items![index].anhDanhMuc,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    items![index].tenDanhMuc,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}