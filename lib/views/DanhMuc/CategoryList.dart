import 'package:datn_cntt304_bandogiadung/views/DanhMuc/ProductByCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/DanhMucSPController.dart';
import '../../models/DanhMucSP.dart';
import '../../widgets/listView_DanhMuc.dart';

class CategoryListScreen extends StatefulWidget {
  final String? maKH;

  CategoryListScreen({required this.maKH});

  @override
  _CategoryListScreen createState() => _CategoryListScreen();
}

class _CategoryListScreen extends State<CategoryListScreen> {
  DanhMucSPController danhMucSPController = DanhMucSPController();
  List<DanhMucSP>? items;

  @override
  void initState() {
    super.initState();
    fetchDanhMucSP();
  }

  Future<void> fetchDanhMucSP() async {
    try {
      List<DanhMucSP> fetchedItems = await danhMucSPController.fetchDanhMucSP();
      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        items = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 63),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(left: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.white,
                      ),
                      child: SvgPicture.asset('assets/icons/arrowleft.svg'),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 36),
                    child: ElevatedButton(
                      onPressed: () {
                        print('b');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Image.asset(
                        'assets/icons/account_icon.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh mục',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gabarito',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: DanhMucListView(
                items: items,
                maKH: widget.maKH,
              ),
            ),
          ],
        ),
      ),
    );
  }
}