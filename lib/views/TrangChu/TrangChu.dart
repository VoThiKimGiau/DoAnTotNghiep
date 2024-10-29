import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/GioHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/views/DanhMuc/CategoryList.dart';
import 'package:datn_cntt304_bandogiadung/views/DanhMuc/ProductByCategory.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:datn_cntt304_bandogiadung/widgets/item_SanPham.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/DanhMucSPController.dart';
import '../../widgets/girdView_SanPham.dart';
import '../../widgets/listView_DanhMuc.dart';
import '../GioHang/GioHangPage.dart';

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
          child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      )); // Show loading indicator
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
                            builder: (context) => GioHangPage(
                                  maGioHang: maGioHangValue,
                                  maKH: widget.maKhachHang,
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
                showSearch(
                    context: context,
                    delegate: CustomSearch(maKH: widget.maKhachHang));
              },
              child: AbsorbPointer(
                // Prevents the text field from gaining focus
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF4F4F4),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.transparent),
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
                              builder: (context) => CategoryListScreen(
                                    maKH: widget.maKhachHang,
                                  )));
                    },
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
                              builder: (context) => ProductByCategoryScreen(
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
                                fontWeight: FontWeight.bold, fontSize: 10),
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ))
              ],
            ),
          ),
          SizedBox(
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
                            builder: (context) => ChiTietSanPhamScreen(
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
                            builder: (context) => ChiTietSanPhamScreen(
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
  final String? maKH;

  CustomSearch({this.maKH});

  Future<List<SanPham>> fetchSP() async {
    try {
      return await sanPhamController.fetchSanPham();
    } catch (e) {
      return [];
    }
  }

  Future<List<DanhMucSP>> fetchCategories() async {
    try {
      return await DanhMucSPController().fetchDanhMucSP();
    } catch (e) {
      return [];
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: SvgPicture.asset('assets/icons/arrowleft.svg'),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return _buildCategoryList();
    }

    return FutureBuilder<List<SanPham>>(
      future: fetchSP(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoResults(context);
        }

        final results = snapshot.data!
            .where((item) =>
                item.tenSP.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (results.isEmpty) {
          return _buildNoResults(context);
        }

        return SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            color: Colors.white,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 110,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        CustomBottomSheet.show(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Sắp xếp',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset('assets/icons/arrowdown.svg'),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${results.length} sản phẩm được tìm thấy',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  child: GridViewSanPham(
                    itemsSP: results,
                    maKH: maKH,
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/search_no_result.png'),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                'Xin lỗi không có sản phẩm như bạn tìm kiếm',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                close(context, null);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: const Text(
                'Trở về trang chủ',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return FutureBuilder<List<DanhMucSP>>(
      future: fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories available'));
        }

        final items = snapshot.data!;

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Danh mục sản phẩm',
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
                  maKH: maKH,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomBottomSheet {
  static void show(BuildContext context) {
    List<String> data = ['Gợi ý', 'Mới nhất', 'Giá tăng dần', 'Giá giảm dần'];
    int selectedIndex = -1; // Initialize selected index

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final bottomSheetHeight = screenHeight * 0.5;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.0)),
              ),
              height: bottomSheetHeight,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = -1;
                          });
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const Text(
                        'Sắp xếp',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.all(0),
                          minimumSize: const Size(24, 24),
                          backgroundColor: Colors.white,
                        ),
                        label: const SizedBox.shrink(),
                        icon: const Icon(Icons.close, color: Colors.black),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: selectedIndex == index
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data[index],
                                  style: TextStyle(
                                    color: selectedIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                if (selectedIndex == index)
                                  const Icon(Icons.check,
                                      color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
