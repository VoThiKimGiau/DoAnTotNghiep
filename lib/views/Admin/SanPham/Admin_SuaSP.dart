import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../controllers/DanhMucSPController.dart';
import '../../../models/DanhMucSP.dart';
import '../../../models/SanPham.dart';
import '../../../services/shared_function.dart';
import '../../../services/storage/storage_service.dart';

class AdminSuaSPScreen extends StatefulWidget {
  late String maSP;

  AdminSuaSPScreen({required this.maSP});

  _AdminSuaSPScreen createState() => _AdminSuaSPScreen();
}

class _AdminSuaSPScreen extends State<AdminSuaSPScreen> {
  SanPhamController sanPhamController = SanPhamController();
  SanPham? itemSP;
  bool isLoading = true;

  StorageService storageService = StorageService();
  SharedFunction sharedFunction = SharedFunction();

  final TextEditingController tenSPController = TextEditingController();
  final TextEditingController hinhAnhController = TextEditingController();
  final TextEditingController moTaController = TextEditingController();
  final TextEditingController giaMacDinhController = TextEditingController();

  String? selectedCategory;
  DanhMucSPController danhMucSPController = DanhMucSPController();
  List<DanhMucSP>? dsDanhMuc;
  List<String> dsTenDM = [];

  @override
  void initState() {
    super.initState();
    fetchSP();
  }

  Future<void> fetchSP() async {
    try {
      SanPham fetchedItems = await sanPhamController.getProductByMaSP(widget.maSP);
      setState(() {
        itemSP = fetchedItems;
        isLoading = false;
        tenSPController.text = itemSP!.tenSP;
        hinhAnhController.text = storageService.getImageUrl(itemSP!.hinhAnhMacDinh);
        moTaController.text = itemSP!.moTa;
        selectedCategory = itemSP!.danhMuc;
        giaMacDinhController.text = itemSP!.giaMacDinh.toString();
      });
      await loadTenDM();
    } catch (e) {
      print('Error: $e');
      setState(() {
        itemSP = null;
        isLoading = false;
      });
    }
  }

  Future<void> fetchDanhMucSP() async {
    try {
      List<DanhMucSP> fetchedItems = await danhMucSPController.fetchDanhMucSP();
      if (mounted) {
        setState(() {
          dsDanhMuc = fetchedItems;
          dsTenDM = dsDanhMuc!.map((dm) => dm.tenDanhMuc).toSet().toList();
          isLoading = false;

          if (!dsTenDM.contains(selectedCategory)) {
            selectedCategory = dsTenDM.isNotEmpty ? dsTenDM.first : null;
          }
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          dsDanhMuc = [];
          dsTenDM = [];
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadTenDM() async {
    await fetchDanhMucSP();
  }

  Future<void> saveChanges() async {
    try {
      SanPham updatedSP = SanPham(
        maSP: itemSP!.maSP,
        tenSP: tenSPController.text,
        hinhAnhMacDinh: hinhAnhController.text,
        moTa: moTaController.text,
        danhMuc: selectedCategory ?? '',
        giaMacDinh: double.tryParse(giaMacDinhController.text) ?? 0.0,
      );
      await sanPhamController.updateProduct(itemSP!.maSP, updatedSP);
    } catch (e) {
      print('Error saving changes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 25),
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
                    const SizedBox(width: 50),
                    const Text(
                      'SỬA SẢN PHẨM',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : Column(
                  children: [
                    Center(
                      child: Image.network(
                        storageService.getImageUrl(itemSP!.hinhAnhMacDinh),
                      ),
                    ),
                    TextField(
                      controller: tenSPController,
                      decoration: const InputDecoration(
                        labelText: 'Tên sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: hinhAnhController,
                      decoration: const InputDecoration(
                        labelText: 'Hình ảnh sản phẩm URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: moTaController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Danh mục sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      items: dsTenDM.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: giaMacDinhController,
                      decoration: const InputDecoration(
                        labelText: 'Giá sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Lưu',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}