import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_SuaCTSP.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_ThemCTSP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../controllers/DanhMucSPController.dart';
import '../../../models/DanhMucSP.dart';
import '../../../models/SanPham.dart';
import '../../../services/shared_function.dart';
import '../../../services/storage/storage_service.dart';
import 'Admin_ItemCTSP.dart';
import 'Admin_ItemSP.dart';

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

  ChiTietSPController chiTietSPController = ChiTietSPController();
  List<ChiTietSP> dsCT = [];

  @override
  void initState() {
    super.initState();
    fetchSP();
    fetchDanhMucSP();
    fetchChiTietSP(widget.maSP);
  }

  Future<void> fetchSP() async {
    try {
      SanPham fetchedItems =
          await sanPhamController.getProductByMaSP(widget.maSP);
      setState(() {
        itemSP = fetchedItems;
        isLoading = false;
        tenSPController.text = itemSP!.tenSP;
        hinhAnhController.text =
            storageService.getImageUrl(itemSP!.hinhAnhMacDinh);
        moTaController.text = itemSP!.moTa;
        selectedCategory = itemSP!.danhMuc;
        giaMacDinhController.text = itemSP!.giaMacDinh.toString();
      });
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

      setState(() {
        dsDanhMuc = fetchedItems;
        isLoading = false;

        if (!dsDanhMuc!.any((dm) => dm.maDanhMuc == selectedCategory)) {
          selectedCategory = dsDanhMuc!.isNotEmpty
              ? dsDanhMuc!.first.maDanhMuc
              : null; // Set to the first maDanhMuc if none matches
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

  Future<void> fetchChiTietSP(String maSanPham) async {
    try {
      List<ChiTietSP> fetchedItems =
          await chiTietSPController.layDanhSachCTSPTheoMaSP(maSanPham);

      setState(() {
        dsCT = fetchedItems;
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        dsCT = [];
      });
    }
  }

  Future<void> saveChanges() async {
    try {
      SanPham updatedSP = SanPham(
        maSP: itemSP!.maSP,
        tenSP: tenSPController.text,
        hinhAnhMacDinh: dsCT[0].maHinhAnh,
        moTa: moTaController.text,
        danhMuc: itemSP!.danhMuc,
        giaMacDinh: double.tryParse(giaMacDinhController.text) ?? 0.0,
      );
      await sanPhamController.updateProduct(itemSP!.maSP, updatedSP);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật sản phẩm thành công')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi cập nhật. Vui lòng kiểm tra lại')),
      );
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
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
                        'SỬA SẢN PHẨM',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Center(
                            child: Image.network(
                              storageService
                                  .getImageUrl(itemSP!.hinhAnhMacDinh),
                              height: 250,
                              width: 250,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
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
                            items: dsDanhMuc?.map((DanhMucSP category) {
                              return DropdownMenuItem<String>(
                                value:
                                    category.maDanhMuc, // Ensure this is unique
                                child:
                                    Text(category.tenDanhMuc), // Display name
                              );
                            }).toList(),
                            // Ensure you use toList() directly without toSet()
                            onChanged: (String? newValue) {
                              print("Danh mục sản phẩm:");
                              dsDanhMuc?.forEach((dm) {
                                print(
                                    'Mã danh mục: ${dm.maDanhMuc}, Tên danh mục: ${dm.tenDanhMuc}');
                              });
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
                          ElevatedButton(
                            onPressed: saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            child: const Text(
                              'Lưu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text('Chi tiết sản phẩm:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdminThemCTSP(
                                                maSP: itemSP!.maSP)));
                                  },
                                  child: const Text('Thêm chi tiết')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dsCT.length,
                            itemBuilder: (context, index) {
                              final product = dsCT[index];
                              return ItemCTSP_Admin(
                                product: product,
                                onUpdate: () => fetchChiTietSP(widget.maSP),
                              );
                            },
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
