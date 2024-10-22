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

  @override
  void initState() {
    super.initState();
    fetchSP(widget.maSP!);
    fetchChiTietSP(widget.maSP!);
    fetchSPTuongTu();
  }

  Future<void> fetchSP(String maSanPham) async {
    try {
      SanPham fetchedItem = await sanPhamController.getProductByMaSP(maSanPham);
      setState(() {
        item = fetchedItem;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e'); // Xử lý lỗi
      setState(() {
        item = null;
        isLoading = false;
      });
    }
  }

  Future<void> fetchChiTietSP(String maSanPham) async {
    try {
      List<ChiTietSP> fetchedItems =
          await chiTietSPController.layDanhSachCTSPTheoMaSP(maSanPham);
      setState(() {
        dsCTSP = fetchedItems; // Cập nhật danh sách
        getDSHinhAnh();
      });
    } catch (e) {
      print('Error: $e'); // Xử lý lỗi
      setState(() {
        dsCTSP = []; // Đặt danh sách thành rỗng nếu có lỗi
      });
    }
  }

  void getDSHinhAnh() {
    for (ChiTietSP ct in dsCTSP) {
      dsHinhSP.add(ct.maHinhAnh);
    }
  }

  Future<void> fetchSPTuongTu() async {
    try {
      // Gọi phương thức từ controller
      List<SanPham> fetchedItems = await sanPhamController.fetchSanPham();
      setState(() {
        itemsSP = fetchedItems; // Cập nhật danh sách
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e'); // Xử lý lỗi
      setState(() {
        itemsSP = []; // Đặt danh sách thành rỗng nếu có lỗi
        isLoading = false;
      });
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
                  ? const CircularProgressIndicator() // Hiển thị loader trong khi đang tải
                  : item == null
                      ? const Text('Không tìm thấy sản phẩm.')
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
                              margin: const EdgeInsets.only(left: 23, top: 24),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Sản phẩm tương tự ',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Gabarito'),
                                ),
                              )
                            ),
                            // Container(
                            //     height: 280,
                            //     child: ListView.builder(
                            //       scrollDirection: Axis.horizontal,
                            //       itemCount: itemsSP!.length >= 5 ? 5 : itemsSP!.length,
                            //       itemBuilder: (context, index) {
                            //         return GestureDetector(
                            //           onTap: () async{
                            //             await Navigator.push(context, MaterialPageRoute(builder: (context) => ChiTietSanPhamScreen(maSP: itemsSP![index].maSP)),);
                            //           },
                            //           child: SanPhamItem(item: itemsSP![index]),
                            //         );
                            //       },
                            //     )),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
