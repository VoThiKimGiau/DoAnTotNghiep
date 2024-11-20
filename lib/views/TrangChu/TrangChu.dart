import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/GioHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/views/DanhMuc/CategoryList.dart';
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

  int selectedCategoryIndex = 0;

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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 45,
                  child: GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearch(
                          maKH: widget.maKhachHang,
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      // Prevents the text field from gaining focus
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFDDDDDD),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          prefixIcon: Image.asset('assets/icons/search.png'),
                          hintText: 'Tìm kiếm',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Danh mục',
                    style: TextStyle(
                        fontFamily: 'Gabarito',
                        fontSize: 19,
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
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              height: items!.length >= 10 ? 170 : 90,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        8,
                            (colIndex) {
                          int itemIndex = colIndex;

                          if (itemIndex >= items!.length) return Container();

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategoryIndex = itemIndex;
                              });
                            },
                            child: Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                color: selectedCategoryIndex == itemIndex
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: selectedCategoryIndex == itemIndex
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  width: selectedCategoryIndex == itemIndex ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: selectedCategoryIndex == itemIndex
                                    ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 5,
                                  ),
                                ]
                                    : [],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start, // Align items at the top
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircleAvatar(
                                      radius: 15,
                                      child: ClipOval(
                                        child: Image.network(
                                          items![itemIndex].anhDanhMuc,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    items![itemIndex].tenDanhMuc,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: selectedCategoryIndex == itemIndex
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (items!.length >= 10)
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          6,
                              (colIndex) {
                            int itemIndex = 6 + colIndex;

                            if (itemIndex >= items!.length) return Container();

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategoryIndex = itemIndex;
                                });
                              },
                              child: Container(
                                width: 90,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: selectedCategoryIndex == itemIndex
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selectedCategoryIndex == itemIndex
                                        ? AppColors.primaryColor
                                        : Colors.transparent,
                                    width: selectedCategoryIndex == itemIndex ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: selectedCategoryIndex == itemIndex
                                      ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 5,
                                    ),
                                  ]
                                      : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start, // Align items at the top
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircleAvatar(
                                        radius: 15,
                                        child: ClipOval(
                                          child: Image.network(
                                            items![itemIndex].anhDanhMuc,
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      items![itemIndex].tenDanhMuc,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: selectedCategoryIndex == itemIndex
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SanPham>>(
              future: danhMucSPController.fetchProductByCategory(
                items![selectedCategoryIndex].maDanhMuc,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available.'));
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: const Color(0xFFf8f8ff),
                  child: GridViewSanPham(
                    itemsSP: snapshot.data!,
                    maKH: widget.maKhachHang,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class CustomSearch extends SearchDelegate {
  final SanPhamController sanPhamController = SanPhamController();
  final String? maKH;

  int? selectedSortIndex;

  List<SanPham> searchResults = [];

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

        searchResults = snapshot.data!
            .where((item) =>
                item.tenSP.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (searchResults.isEmpty) {
          return _buildNoResults(context);
        }

        if (selectedSortIndex != null) {
          if (selectedSortIndex == 2) {
            searchResults.sort((a, b) => a.giaMacDinh.compareTo(b.giaMacDinh));
          } else if (selectedSortIndex == 3) {
            searchResults.sort((a, b) => b.giaMacDinh.compareTo(a.giaMacDinh));
          }
        }

        Future<void> navigateToSort() async {
          final result = await CustomBottomSheet.show(context,
              onSortSelected: (index) {
                selectedSortIndex = index;
              });

          if (result == true) {
            _buildSearchResults(context);
          }
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
                        navigateToSort();
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
                      '${searchResults.length} sản phẩm được tìm thấy',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  child: GridViewSanPham(
                    itemsSP: searchResults,
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
  static Future<bool?> show(BuildContext context,
      {required Function(int) onSortSelected}) {
    List<String> data = ['Gợi ý', 'Mới nhất', 'Giá tăng dần', 'Giá giảm dần'];
    int selectedIndex = -1;

    return showModalBottomSheet<bool>(
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              height: bottomSheetHeight,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = -1;
                          });
                          Navigator.pop(context, true);
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
                          Navigator.pop(context, false);
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
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              onSortSelected(index);
                              Navigator.pop(context, true);
                            });
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
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
                                  const Icon(Icons.check, color: Colors.white, size: 20),
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
    ).then((value) => value ?? false);
  }
}
