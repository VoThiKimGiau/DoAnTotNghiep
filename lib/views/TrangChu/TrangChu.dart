import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/GioHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/views/DanhMuc/CategoryList.dart';
import 'package:datn_cntt304_bandogiadung/views/DanhMuc/ProductByCategory.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:datn_cntt304_bandogiadung/widgets/item_SanPham.dart';
import 'package:datn_cntt304_bandogiadung/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/DanhMucSPController.dart';
import '../GioHang/GioHangPage.dart';
import 'SearchSP.dart';

class TrangChuScreen extends StatefulWidget {
  final String? maKhachHang;

  TrangChuScreen({required this.maKhachHang});

  @override
  State<TrangChuScreen> createState() => _TrangChuScreen();
}

class _TrangChuScreen extends State<TrangChuScreen> {
  DanhMucSPController danhMucSPController = DanhMucSPController();
  List<DanhMucSP>? items;

  SanPhamController sanPhamController = SanPhamController();
  List<SanPham>? itemsSP;
  bool isLoading = true;

  GioHangController gioHangController = GioHangController();
  late Future<String> maGioHang;

  @override
  void initState() {
    super.initState();
    fetchDanhMucSP();
    fetchSP();
    fetchMaGioHang();
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

  Future<void> fetchSP() async {
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

  Future<void> fetchMaGioHang() async {
    maGioHang = gioHangController.getMaGHByMaKH(widget.maKhachHang);
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // Show loading indicator
    }

    if (items == null || items!.isEmpty) {
      return const Center(
          child: Text('No products available.')); // Handle empty state
    }

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            print('a');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Image.asset('assets/icons/account_icon.png'),
                        ),
                      ),
                      const Text('CỬA HÀNG GIA DỤNG HUIT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              fontSize: 15)),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            String maGioHangValue = await maGioHang;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GioHangPage(
                                          maGioHang: maGioHangValue,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: SvgPicture.asset('assets/icons/bag2.svg'),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: GestureDetector(
                      onTap: () {
                        showSearch(context: context, delegate: CustomSearch());
                      },
                      child: AbsorbPointer( // Prevents the text field from gaining focus
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF4F4F4),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.transparent),
                            ),
                            prefixIcon: Image.asset('assets/icons/search.png'),
                            hintText: 'Tìm kiếm',
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Danh mục',
                            style: TextStyle(
                                fontFamily: 'Gabarito',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor)),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryListScreen(
                                            maKH: widget.maKhachHang,
                                          )));
                            },
                            child: const Text(
                              'Xem tất cả',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items!.length >= 5 ? 5 : items!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductByCategoryScreen(
                                            maDanhMuc: items![index].maDanhMuc,
                                            maKH: widget.maKhachHang,
                                          )));
                            },
                            child: Container(
                              width: 140,
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircleAvatar(
                                      radius: 30,
                                      child: ClipOval(
                                        child: Image.network(
                                          items![index].anhDanhMuc,
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    items![index].tenDanhMuc, // Tên của mục
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 36, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Bán chạy',
                            style: TextStyle(
                                fontFamily: 'Gabarito',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor)),
                        TextButton(
                            onPressed: () {
                              print('a');
                            },
                            child: const Text(
                              'Xem tất cả',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ))
                      ],
                    ),
                  ),
                  Container(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: itemsSP!.length >= 10 ? 10 : itemsSP!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChiTietSanPhamScreen(
                                          maSP: itemsSP![index].maSP,
                                          maKH: widget.maKhachHang,
                                        )),
                              );
                            },
                            child: SanPhamItem(item: itemsSP![index]),
                          );
                        },
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 36, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Mới',
                            style: TextStyle(
                                fontFamily: 'Gabarito',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor)),
                        TextButton(
                            onPressed: () {
                              print('a');
                            },
                            child: const Text(
                              'Xem tất cả',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ))
                      ],
                    ),
                  ),
                  Container(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: itemsSP!.length >= 10 ? 10 : itemsSP!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChiTietSanPhamScreen(
                                          maSP: itemsSP![index].maSP,
                                          maKH: widget.maKhachHang,
                                        )),
                              );
                            },
                            child: SanPhamItem(item: itemsSP![index]),
                          );
                        },
                      )),
                ],
              )),
        ));
  }
}

class CustomSearch extends SearchDelegate {
  final SanPhamController sanPhamController = SanPhamController();
  late Future<List<SanPham>> itemsSP;

  // Fetch the products asynchronously
  Future<List<SanPham>> fetchSP() async {
    try {
      return await sanPhamController.fetchSanPham();
    } catch (e) {
      return []; // Return an empty list on error
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; // Clear the search query
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // Close the search
      },
      icon: SvgPicture.asset('assets/icons/arrowleft.svg'),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<SanPham>>(
      future: fetchSP(), // Fetch products
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found'));
        }

        final results = snapshot.data!
            .where((item) => item.tenSP.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return ListTile(
              title: Text(item.tenSP),
              onTap: () {
                close(context, item); // Close with the selected item
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<SanPham>>(
      future: fetchSP(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No suggestions available'));
        }

        final suggestions = snapshot.data!
            .where((item) => item.tenSP.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final item = suggestions[index];
            return ListTile(
              title: Text(item.tenSP),
              onTap: () {
                query = item.tenSP; // Set query to tapped suggestion
                showResults(context); // Show results for the selected suggestion
              },
            );
          },
        );
      },
    );
  }
}