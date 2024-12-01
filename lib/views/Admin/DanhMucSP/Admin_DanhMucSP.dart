import 'dart:io';
import 'package:datn_cntt304_bandogiadung/views/Admin/DanhMucSP/Admin_SuaDM.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../colors/color.dart';
import '../../../controllers/DanhMucSPController.dart';
import '../../../models/DanhMucSP.dart';
import '../../../widgets/listView_DanhMuc.dart';
import 'Admin_ItemCategory.dart';

class AdminCategoryListScreen extends StatefulWidget {
  @override
  _AdminCategoryListScreen createState() => _AdminCategoryListScreen();
}

class _AdminCategoryListScreen extends State<AdminCategoryListScreen> {
  DanhMucSPController danhMucSPController = DanhMucSPController();
  List<DanhMucSP>? items;
  String? uploadedImageUrl;

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
      print('Error fetching categories: $e');
      setState(() {
        items = [];
      });
    }
  }

  Future<void> _uploadImage(String categoryId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String fileName = 'A$categoryId.jpg';
      final FirebaseStorage storage = FirebaseStorage.instance;

      try {
        await storage.ref(fileName).putFile(File(image.path));
        String downloadUrl = await storage.ref(fileName).getDownloadURL();

        setState(() {
          uploadedImageUrl = downloadUrl;
        });
        _showErrorDialog('Tải hình ảnh lên thành công!', 'Thông báo');
      } catch (e) {
        print('Error uploading image: $e');
        _showErrorDialog('Tải hình ảnh lên thất bại', 'Lỗi');
      }
    }
  }

  void _showAddCategoryDialog() {
    TextEditingController newCategoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm danh mục mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newCategoryController,
                decoration: const InputDecoration(labelText: 'Tên danh mục'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  int soTang = items?.length ?? 0;
                  await _uploadImage('DM${soTang + 1}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text('Tải hình ảnh lên',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (newCategoryController.text.isNotEmpty) {
                  int soTang = items?.length ?? 0;
                  try {
                    DanhMucSP newCategory = DanhMucSP(
                      maDanhMuc: 'DM${soTang + 1}',
                      tenDanhMuc: newCategoryController.text,
                      anhDanhMuc: uploadedImageUrl ?? '',
                    );
                    await danhMucSPController.addDanhMucSP(newCategory);
                    fetchDanhMucSP();
                    Navigator.of(context).pop();
                    _showErrorDialog('Thêm danh mục thành công', 'Thông báo');
                  } catch (e) {
                    print('Error adding category: $e');
                    _showErrorDialog('Thêm danh mục thất bại', 'Lỗi');
                  }
                } else {
                  _showErrorDialog('Vui lòng nhập tên danh mục.', 'Thông báo');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: const Text('Lưu', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 24, top: 30, bottom: 15),
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
                      hintText: 'Tìm kiếm',
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
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh mục',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showAddCategoryDialog,
                        child: const Text(
                          'Thêm danh mục',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: items == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, index) {
                          return AdminItemCategory(
                            category: items![index],
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminSuaDM(
                                    maDanhMuc: items![index].maDanhMuc,
                                  ),
                                ),
                              );

                              if (result) {
                                fetchDanhMucSP();
                              }
                            },
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

class CustomSearch extends SearchDelegate {
  final DanhMucSPController danhMucSPController = DanhMucSPController();

  Future<List<DanhMucSP>> fetchDM() async {
    try {
      return await danhMucSPController.fetchDanhMucSP();
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
    return FutureBuilder<List<DanhMucSP>>(
      future: fetchDM(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('Không có danh mục sản phẩm trùng khớp!'));
        }

        final results = snapshot.data!
            .where((item) =>
                item.tenDanhMuc.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (results.isEmpty) {
          return const Center(
            child: Text(
              'Không có danh mục sản phẩm trùng khớp!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gabarito'),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final product = results[index];
              return AdminItemCategory(
                category: product,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminSuaDM(
                        maDanhMuc: product.maDanhMuc,
                      ),
                    ),
                  );

                  if (result) {
                    fetchDM();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<DanhMucSP>>(
      future: fetchDM(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('Không có danh mục sản phẩm trùng khớp!'));
        }

        final suggestions = snapshot.data!
            .where((item) =>
                item.tenDanhMuc.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (suggestions.isEmpty) {
          return const Center(
            child: Text(
              'Không có danh mục sản phẩm trùng khớp!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gabarito'),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final item = suggestions[index];
              return AdminItemCategory(
                category: item,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminSuaDM(
                        maDanhMuc: item.maDanhMuc,
                      ),
                    ),
                  );

                  if (result) {
                    fetchDM();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
