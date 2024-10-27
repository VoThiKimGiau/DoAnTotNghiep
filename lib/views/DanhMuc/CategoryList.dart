import 'package:datn_cntt304_bandogiadung/views/DanhMuc/ProductByCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/DanhMucSPController.dart';
import '../../models/DanhMucSP.dart';

class CategoryListScreen extends StatefulWidget {
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
                  )),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: items == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductByCategoryScreen(
                                                maDanhMuc:
                                                    items![index].maDanhMuc)));
                              },
                              style: ElevatedButton.styleFrom(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
