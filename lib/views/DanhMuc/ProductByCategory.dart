import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:datn_cntt304_bandogiadung/widgets/item_SanPham.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/DanhMucSPController.dart';
import '../../widgets/girdView_SanPham.dart';

class ProductByCategoryScreen extends StatefulWidget {
  final String? maDanhMuc;
  final String? maKH;

  ProductByCategoryScreen({required this.maDanhMuc, this.maKH});

  @override
  _ProductByCategoryScreen createState() => _ProductByCategoryScreen();
}

class _ProductByCategoryScreen extends State<ProductByCategoryScreen> {
  DanhMucSPController danhMucSPController = DanhMucSPController();
  List<SanPham>? itemsSP;
  String? tenDM;
  bool isLoading = true; // Variable to track loading state

  StorageService storageService = StorageService();
  SharedFunction sharedFunction = SharedFunction();

  @override
  void initState() {
    super.initState();
    fetchSPByDM();
    fetchTenDM();
  }

  Future<void> fetchSPByDM() async {
    try {
      List<SanPham> fetchedItems =
          await danhMucSPController.fetchProductByCategory(widget.maDanhMuc);
      setState(() {
        itemsSP = fetchedItems;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        itemsSP = [];
      });
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching
      });
    }
  }

  Future<void> fetchTenDM() async {
    try {
      String? fetchedItems =
          await danhMucSPController.fetchTenDM(widget.maDanhMuc);
      setState(() {
        tenDM = fetchedItems;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        tenDM = '';
      });
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading // Check if loading
            ? const Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : Column(
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
                            child:
                                SvgPicture.asset('assets/icons/arrowleft.svg'),
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tenDM != null && itemsSP != null
                            ? '$tenDM (${itemsSP!.length})'
                            : 'Loading...',
                        style: const TextStyle(
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
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridViewSanPham(
                        itemsSP: itemsSP ?? [],
                        maKH: widget.maKH,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
