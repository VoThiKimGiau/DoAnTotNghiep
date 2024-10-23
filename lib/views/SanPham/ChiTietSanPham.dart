import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../colors/color.dart';
import '../../controllers/SanPhamController.dart';
import '../../models/SanPham.dart';
import '../../widgets/item_SanPham.dart';
import 'CircleButtonColor.dart';

class ChiTietSanPhamScreen extends StatefulWidget {
  final String? maSP;

  ChiTietSanPhamScreen({required this.maSP});

  @override
  _ChiTietSanPhamScreen createState() => _ChiTietSanPhamScreen();
}

class _ChiTietSanPhamScreen extends State<ChiTietSanPhamScreen> {
  SanPhamController sanPhamController = SanPhamController();
  SanPham? item;
  bool isLoading = true;

  ChiTietSPController chiTietSPController = ChiTietSPController();
  StorageService storageService = StorageService();
  SharedFunction sharedFunction = SharedFunction();

  List<ChiTietSP> dsCTSP = [];
  List<String> dsHinhSP = [];
  List<SanPham>? itemsSP;
  List<String> dsMauSP = [];
  List<String> dsKichCo = [];

  @override
  void initState() {
    super.initState();
    fetchSP(widget.maSP!);
    fetchChiTietSP(widget.maSP!);
  }

  Future<void> fetchSP(String maSanPham) async {
    setState(() {
      isLoading = true;
    });
    try {
      SanPham fetchedItem = await sanPhamController.getProductByMaSP(maSanPham);
      setState(() {
        item = fetchedItem;
        fetchSPTuongTu(item!.danhMuc);
        getDSMau();
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        item = null; // Ensure item is null if there's an error
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading after fetching
      });
    }
  }

  Future<void> fetchChiTietSP(String maSanPham) async {
    try {
      List<ChiTietSP> fetchedItems =
      await chiTietSPController.layDanhSachCTSPTheoMaSP(maSanPham);
      setState(() {
        dsCTSP = fetchedItems; // Update list
        getDSHinhAnh();
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        dsCTSP = []; // Set list to empty on error
      });
    }
  }

  void getDSHinhAnh() {
    dsHinhSP = dsCTSP.map((ct) => ct.maHinhAnh).toList();
  }

  Future<void> fetchSPTuongTu(String maDanhMuc) async {
    try {
      List<SanPham> fetchedItems =
      await sanPhamController.getProductByCategory(maDanhMuc);
      setState(() {
        itemsSP = fetchedItems;
        removeSPHienTai();
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        itemsSP = []; // Set list to empty on error
      });
    }
  }

  void removeSPHienTai() {
    itemsSP?.removeWhere((sp) => sp.maSP == item?.maSP);
  }

  void getDSMau() {
    for (ChiTietSP ct in dsCTSP) {
      dsMauSP.add(ct.maMau);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                      margin: EdgeInsets.only(right: 36),
                      child: ElevatedButton(
                        onPressed: () {
                          print('b');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                        ),
                        child: SvgPicture.asset('assets/icons/heart.svg'),
                      ),
                    )
                  ],
                ),
              ),
              isLoading
                  ? const Center(
                  child:
                  CircularProgressIndicator()) // Display loader while loading
                  : item == null
                  ? const Center(child: Text('Không tìm thấy sản phẩm.'))
                  : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dsHinhSP.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    top: 24,
                                    bottom: 24,
                                    left: 24,
                                    right: 10),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  child: Image.network(
                                    storageService
                                        .getImageUrl(dsHinhSP[index]),
                                    fit: BoxFit.cover,
                                    width: 160,
                                    height: 250,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item!.tenSP,
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontFamily: 'Gabarito',
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            sharedFunction
                                .formatCurrency(item!.giaMacDinh),
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryColor,
                                fontFamily: 'Gabarito',
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 23, top: 24, right: 25),
                    height: 150,
                    child: SingleChildScrollView(
                      child: Text(
                        item!.moTa,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Container(
                      margin:
                      const EdgeInsets.only(left: 23, top: 24),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sản phẩm tương tự ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gabarito'),
                        ),
                      )),
                  Container(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: itemsSP != null
                            ? (itemsSP!.length >= 5
                            ? 5
                            : itemsSP!.length)
                            : 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChiTietSanPhamScreen(
                                          maSP: itemsSP![index].maSP),
                                ),
                              );
                            },
                            child: SanPhamItem(item: itemsSP![index]),
                          );
                        },
                      )),
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          CustomBottomSheet.show(
                              context, "Đặt hàng", dsCTSP, dsMauSP, dsKichCo);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: const Text(
                          'Đặt hàng',
                          style: TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          CustomBottomSheet.show(
                              context, "Thêm vào giỏ hàng", dsCTSP, dsMauSP, dsKichCo);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: const Text(
                          'Thêm vào giỏ hàng',
                          style: TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomSheet {
  static void show(BuildContext context, String buttonText,
      List<ChiTietSP> dsCTSP, List<String> dsMau, List<String> dsKichCo) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery
            .of(context)
            .size
            .height;
        final bottomSheetHeight = screenHeight * 0.75;

        return Container(
          height: bottomSheetHeight,
          width: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 5,
                right: 10,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(18, 18),
                      padding: const EdgeInsets.all(0),
                    ),
                    label: const SizedBox.shrink(),
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.black,
                    )),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 17, left: 25),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Màu sắc',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                      ),
                      Container(
                        child: Column(
                          children: [
                            CircleButtonColor(items: dsMau),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity, // Set width to infinity
                        child: ElevatedButton(
                          onPressed: () {
                            print('a');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
