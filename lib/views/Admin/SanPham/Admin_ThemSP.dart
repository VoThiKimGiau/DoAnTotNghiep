import 'dart:io';
import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DanhMucSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_ThemCTSP.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../models/SanPham.dart';
import 'Admin_ItemCTSP.dart';

class AdminThemSP extends StatefulWidget {
  @override
  _AdminThemSPState createState() => _AdminThemSPState();
}

class _AdminThemSPState extends State<AdminThemSP> {
  final TextEditingController tenSPController = TextEditingController();
  final TextEditingController moTaController = TextEditingController();
  bool isLoading = true;
  String? selectedDanhMuc;
  String? uploadedImageUrl;

  ChiTietSPController chiTietSPController = ChiTietSPController();
  SanPhamController sanPhamController = SanPhamController();
  DanhMucSPController danhMucSPController = DanhMucSPController();

  List<ChiTietSP>? dsCT;
  List<DanhMucSP>? dsDanhMuc;
  SanPham? itemSP;

  double? giaMD;
  String? newID;

  @override
  void initState() {
    super.initState();
    fetchDanhMucSP();
    fetchNewID();
  }

  Future<void> updateSP() async {
    try {
      SanPham updatedSP = SanPham(
        maSP: itemSP!.maSP,
        tenSP: tenSPController.text,
        hinhAnhMacDinh: uploadedImageUrl ?? 'HA0',
        moTa: moTaController.text,
        danhMuc: itemSP!.danhMuc,
        giaMacDinh: giaMD ?? 0.0,
      );
      await sanPhamController.updateProduct(itemSP!.maSP, updatedSP);
    } catch (e) {
      print('Error saving changes: $e');
    }
  }

  Future<void> fetchCTSP() async {
    try {
      List<ChiTietSP> fetchedItems =
      await chiTietSPController.layDanhSachCTSPTheoMaSP(itemSP!.maSP);
      setState(() {
        dsCT = fetchedItems;
        uploadedImageUrl = fetchedItems[0].maHinhAnh;
        giaMD = fetchedItems[0].giaBan;
        isLoading = false;
      });
      await updateSP();
    } catch (e) {
      print('Error: $e');
      setState(() {
        dsCT = [];
        isLoading = false;
      });
    }
  }

  Future<void> fetchSP() async {
    try {
      SanPham fetchedItem =
      await sanPhamController.getProductByMaSP(newID ?? '');
      setState(() {
        itemSP = fetchedItem;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        itemSP = null;
      });
    }
  }

  Future<void> fetchDanhMucSP() async {
    try {
      List<DanhMucSP> fetchedItems = await danhMucSPController.fetchDanhMucSP();
      setState(() {
        dsDanhMuc = fetchedItems;
        isLoading = false;
        if (dsDanhMuc!.isNotEmpty) {
          selectedDanhMuc = dsDanhMuc!.first.maDanhMuc;
        }
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        dsDanhMuc = [];
        isLoading = false;
      });
    }
  }

  Future<void> fetchNewID() async {
    try {
      int fetchItems = await sanPhamController.fetchAllSanPham();
      setState(() {
        newID = 'SP${fetchItems + 1}';
      });
    } catch (e) {
      setState(() {
        newID = '';
      });
    }
  }

  Future<void> _saveProduct() async {
    try {
      await fetchNewID();
      await sanPhamController.addSanPham(SanPham(
          maSP: newID ?? '',
          tenSP: tenSPController.text,
          moTa: moTaController.text,
          danhMuc: selectedDanhMuc ?? '',
          hinhAnhMacDinh: 'HA0',
          giaMacDinh: 0));

      fetchSP();
      _showErrorDialog('Thêm sản phẩm thành công', 'Thông báo');
    } catch (e) {
      _showErrorDialog('Thêm sản phẩm thất bại. Vui lòng thử lại!', 'Lỗi');
    }
  }

  Future<void> _uploadImage(String categoryId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String fileName = 'A${categoryId}.jpg';
      final FirebaseStorage storage = FirebaseStorage.instance;

      try {
        // Check if an image already exists
        if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty) {
          // Delete the old image
          final oldImageRef = storage.refFromURL(uploadedImageUrl!);
          await oldImageRef.delete();
        }

        // Upload the new image
        await storage.ref(fileName).putFile(File(image.path));
        String downloadUrl = await storage.ref(fileName).getDownloadURL();

        setState(() {
          uploadedImageUrl = downloadUrl; // Store the uploaded image URL
        });
        _showErrorDialog('Tải hình ảnh lên thành công!', 'Thông báo');
      } catch (e) {
        print('Error uploading image: $e');
        _showErrorDialog('Tải hình ảnh lên thất bại', 'Lỗi');
      }
    }
  }

  Future<void> _addChiTietSP() async {
    fetchSP();
    if (itemSP == null) {
      _showErrorDialog(
          'Vui lòng thêm sản phẩm trước khi thêm chi tiết sản phẩm',
          'Cảnh báo');
    } else {
      final isChange = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AdminThemCTSP(
                    maSP: newID ?? '',
                  )));

      if (isChange) {
        await fetchCTSP();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.6,
            child: const Text(
              'Thêm sản phẩm',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            )),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tenSPController,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            TextField(
              controller: moTaController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : _buildCategoryDropdown(),
            const SizedBox(height: 20),
            _buildActionButton('Lưu sản phẩm', _saveProduct),
            _buildActionButton('Thêm chi tiết sản phẩm', _addChiTietSP),
            const SizedBox(height: 20),
            _buildDetailsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedDanhMuc,
            decoration: const InputDecoration(
              labelText: 'Danh mục sản phẩm',
              border: OutlineInputBorder(),
            ),
            items: dsDanhMuc?.map((DanhMucSP category) {
              return DropdownMenuItem<String>(
                value: category.maDanhMuc,
                child: Text(category.tenDanhMuc),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedDanhMuc = newValue;
              });
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddCategoryDialog(),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          minimumSize: const Size(double.infinity, 40),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDetailsList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: dsCT?.length ?? 0,
        itemBuilder: (context, index) {
          final product = dsCT![index];
          return ItemCTSP_Admin(
            product: product,
            onUpdate: () => fetchCTSP(),
          );
        },
      ),
    );
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
                  await _uploadImage('DM${dsDanhMuc!.length + 1}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text(
                  'Tải hình ảnh lên',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (newCategoryController.text.isNotEmpty) {
                  try {
                    DanhMucSP newCategory = DanhMucSP(
                      maDanhMuc: 'DM${dsDanhMuc!.length + 1}',
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
              child: const Text(
                'Lưu',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Hủy',
                style: TextStyle(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
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
}
