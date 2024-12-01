import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/DanhMucSP/Admin_DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/KichCo/Admin_KichCo.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/MauSP/Admin_MauSP.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_ItemCTSP.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_ThemSP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../controllers/DanhMucSPController.dart';
import '../../../controllers/SanPhamController.dart';
import '../../../models/DanhMucSP.dart';
import '../../../models/SanPham.dart';
import '../NhaCungCap/Admin_NhaCC.dart';
import 'Admin_ItemSP.dart';

class AdminSanPhamScreen extends StatefulWidget {
  _AdminSanPhamScreen createState() => _AdminSanPhamScreen();
}

class _AdminSanPhamScreen extends State<AdminSanPhamScreen> {
  DanhMucSPController danhMucSPController = DanhMucSPController();
  List<DanhMucSP>? dsDanhMuc;
  int selectedCategoryIndex = 0;
  bool isLoading = true;

  StorageService storageService = StorageService();
  SharedFunction sharedFunction = SharedFunction();

  @override
  void initState() {
    super.initState();
    fetchDanhMucSP();
  }

  Future<void> fetchDanhMucSP() async {
    try {
      List<DanhMucSP> fetchedItems = await danhMucSPController.fetchDanhMucSP();
      if (mounted) {
        setState(() {
          dsDanhMuc = fetchedItems;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          dsDanhMuc = [];
          isLoading = false;
        });
      }
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
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      'QUẢN LÝ SẢN PHẨM',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearch(),
                  );
                },
                child: AbsorbPointer(
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
                      hintText: 'Tìm kiếm theo tên',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminSupplierListScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                      ),
                      label: const Text(
                        'Quản lý nhà cung cấp',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Gabarito',
                        ),
                      ),
                      icon: Image.asset(
                        'assets/icons/supplier.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminKichCoScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                      ),
                      label: const Text(
                        'Quản lý kích cỡ sản phẩm',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Gabarito',
                        ),
                      ),
                      icon: Image.asset(
                        'assets/icons/size.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminMauSPScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                      ),
                      label: const Text(
                        'Quản lý màu sản phẩm',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Gabarito',
                        ),
                      ),
                      icon: Image.asset(
                        'assets/icons/color.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminCategoryListScreen()));
                      },
                      child: const Text(
                        'Tất cả danh mục',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ))),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dsDanhMuc?.length ?? 0,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedCategoryIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 5,
                                      )
                                    ]
                                  : [],
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                dsDanhMuc![index].tenDanhMuc ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(
              height: 40,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminThemSP()));
                      },
                      child: const Text(
                        'Thêm sản phẩm',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ))),
            ),
            Expanded(
              child: FutureBuilder<List<SanPham>>(
                future: danhMucSPController.fetchProductByCategory(
                  dsDanhMuc != null && dsDanhMuc!.isNotEmpty
                      ? dsDanhMuc![selectedCategoryIndex].maDanhMuc
                      : '',
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products available.'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return ItemSP_Admin(product: product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  final SanPhamController sanPhamController = SanPhamController();

  Future<List<SanPham>> fetchSP() async {
    try {
      return await sanPhamController.fetchSanPham();
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
    return FutureBuilder<List<SanPham>>(
      future: fetchSP(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sản phẩm trùng khớp!'));
        }

        final results = snapshot.data!
            .where((item) =>
                item.tenSP.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (results.isEmpty) {
          return const Center(
              child: Text(
            'Không có sản phẩm trùng khớp!',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gabarito'),
          ));
        }

        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final product = results[index];
              return ItemSP_Admin(product: product);
            },
          ),
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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sản phẩm trùng khớp!'));
        }

        final suggestions = snapshot.data!
            .where((item) =>
                item.tenSP.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (suggestions.isEmpty) {
          return const Center(
              child: Text(
            'Không có sản phẩm trùng khớp!',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gabarito'),
          ));
        }

        return Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final item = suggestions[index];
                return ItemSP_Admin(product: item);
              },
            ));
      },
    );
  }
}
