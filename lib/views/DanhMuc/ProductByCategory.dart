import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/DanhMucSPController.dart';

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
        body: isLoading // Check if loading
            ? Center(
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
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10, // Spacing between columns
                          mainAxisSpacing: 10, // Spacing between rows
                          childAspectRatio: 0.6, // Aspect ratio of each cell
                        ),
                        itemCount: itemsSP!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChiTietSanPhamScreen(
                                              maSP: itemsSP![index].maSP,
                                              maKH: widget.maKH,
                                            )));
                              },
                              child: SizedBox(
                                height: 280,
                                child: Card(
                                  elevation: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.network(
                                        storageService.getImageUrl(
                                            itemsSP![index].hinhAnhMacDinh),
                                        height: 200,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 8),
                                          child: Text(
                                            itemsSP![index].tenSP,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            sharedFunction.formatCurrency(
                                                itemsSP![index].giaMacDinh),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
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
