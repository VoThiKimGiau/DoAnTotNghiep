import 'dart:io';

import 'package:datn_cntt304_bandogiadung/controllers/HinhAnhController.dart';
import 'package:datn_cntt304_bandogiadung/models/HinhAnhSP.dart';
import 'package:datn_cntt304_bandogiadung/models/KichCo.dart';
import 'package:datn_cntt304_bandogiadung/models/MauSP.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../../colors/color.dart';
import '../../../controllers/NhaCungCapController.dart';
import '../../../services/storage/storage_service.dart';

class AdminSuaCTSPScreen extends StatefulWidget {
  final String maCTSP;
  final String maSP;

  AdminSuaCTSPScreen({required this.maCTSP, required this.maSP});

  @override
  _AdminSuaCTSPScreenState createState() => _AdminSuaCTSPScreenState();
}

class _AdminSuaCTSPScreenState extends State<AdminSuaCTSPScreen> {
  ChiTietSPController chiTietSPController = ChiTietSPController();
  KichCoController kichCoController = KichCoController();
  MauSPController mauSPController = MauSPController();
  NCCController nccController = NCCController();
  HinhAnhController hinhAnhController = HinhAnhController();
  StorageService storageService = StorageService();

  ChiTietSP? itemCTSP;
  bool isLoading = true;

  final TextEditingController giaBanController = TextEditingController();
  final TextEditingController maHinhAnhController = TextEditingController();
  final TextEditingController slKhoController = TextEditingController();

  String? selectedSize;
  String? selectedColor;
  String? selectedSupplier;

  List<KichCo>? dsKichCo;
  List<MauSP>? dsMau;
  List<NhaCungCap>? dsNCC;

  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchChiTietSP();
    fetchKichCo();
    fetchMau();
    fetchSuppliers();
  }

  Future<void> fetchChiTietSP() async {
    try {
      ChiTietSP fetchedItem =
          await chiTietSPController.layCTSPTheoMa(widget.maCTSP);
      if (fetchedItem != null) {
        setState(() {
          itemCTSP = fetchedItem;
          giaBanController.text = itemCTSP!.giaBan.toString();
          maHinhAnhController.text = itemCTSP!.maHinhAnh;
          slKhoController.text = itemCTSP!.slKho.toString();
          selectedSize = itemCTSP!.maKichCo;
          selectedColor = itemCTSP!.maMau;
          selectedSupplier = itemCTSP!.maNCC;
        });
      }
    } catch (e) {
      print('Error fetching ChiTietSP: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchKichCo() async {
    try {
      List<KichCo> fetchedSizes = await kichCoController.fetchAllKichCo();
      setState(() {
        dsKichCo = fetchedSizes;
        isLoading = false;

        if (!dsKichCo!.any((kc) => kc.maKichCo == selectedSize)) {
          selectedSize = dsKichCo!.isNotEmpty ? dsKichCo!.first.maKichCo : null;
        }
      });
    } catch (e) {
      print('Error fetching KichCo: $e');
      setState(() {
        isLoading = false;
        dsKichCo = null;
      });
    }
  }

  Future<void> fetchMau() async {
    try {
      List<MauSP> fetchedColors = await mauSPController.fetchAllMauSP();
      setState(() {
        dsMau = fetchedColors;
        isLoading = false;

        if (!dsMau!.any((m) => m.maMau == selectedColor)) {
          selectedColor = dsMau!.isNotEmpty ? dsMau!.first.maMau : null;
        }
      });
    } catch (e) {
      print('Error fetching Mau: $e');
      setState(() {
        isLoading = false;
        dsMau = null;
      });
    }
  }

  Future<void> fetchSuppliers() async {
    try {
      List<NhaCungCap> fetchedSuppliers = await nccController.fetchSuppliers();
      setState(() {
        dsNCC = fetchedSuppliers;
        isLoading = false;

        if (!dsNCC!.any((ncc) => ncc.maNCC == selectedSupplier)) {
          selectedSupplier = dsNCC!.isNotEmpty ? dsNCC!.first.maNCC : null;
        }
      });
    } catch (e) {
      print('Error fetching Suppliers: $e');
      setState(() {
        isLoading = false;
        dsNCC = null;
      });
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    try {
      ChiTietSP updatedCTSP = ChiTietSP(
        maCTSP: itemCTSP!.maCTSP,
        maSP: widget.maSP,
        maKichCo: selectedSize!,
        maMau: selectedColor!,
        giaBan: double.tryParse(giaBanController.text) ?? 0.0,
        maHinhAnh: itemCTSP!.maHinhAnh,
        maNCC: selectedSupplier!,
        slKho: itemCTSP!.slKho,
      );

      await chiTietSPController.updateChiTietSP(updatedCTSP);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật chi tiết sản phẩm thành công')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      print('Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi cập nhật. Vui lòng kiểm tra lại')),
      );
    }
  }

  Future<void> updateHinhAnhSP(
      String maHA, String url, BuildContext context) async {
    try {
      await hinhAnhController.updateImage(
          maHA, new HinhAnhSP(maHinhAnh: maHA, lienKetURL: url));
    } catch (e) {
      print('Lỗi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi cập nhật. Vui lòng kiểm tra lại')),
      );
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });

    if (_imageFile == null) return;

    String newFileName = '${itemCTSP!.maHinhAnh}.jpg';
    File file = File(_imageFile!.path);

    try {
      // Check if the file already exists
      await _firebaseStorage.ref(newFileName).getDownloadURL();

      // If the file exists, update it
      await _firebaseStorage.ref(newFileName).putFile(file);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật hình ảnh thành công!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải lên!')),
      );

      setState(() {
        fetchChiTietSP();
      });
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
                        'SỬA CHI TIẾT SẢN PHẨM',
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
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Center(
                            child: Image.network(
                              storageService
                                  .getImageUrl(itemCTSP?.maHinhAnh ?? ''),
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _uploadImage(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                //minimumSize: const Size(double.infinity, 40),
                              ),
                              child: const Text(
                                'Tải hình ảnh lên',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )),
                          const SizedBox(height: 30),
                          TextField(
                            controller: giaBanController,
                            decoration: const InputDecoration(
                              labelText: 'Giá bán',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedSize,
                            decoration: const InputDecoration(
                              labelText: 'Kích cỡ',
                              border: OutlineInputBorder(),
                            ),
                            items: dsKichCo?.map((KichCo size) {
                              return DropdownMenuItem<String>(
                                value: size.maKichCo,
                                child: Text(size.tenKichCo),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSize = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedColor,
                            decoration: const InputDecoration(
                              labelText: 'Màu sắc',
                              border: OutlineInputBorder(),
                            ),
                            items: dsMau?.map((MauSP color) {
                              return DropdownMenuItem<String>(
                                value: color.maMau,
                                child: Text(color.tenMau),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedColor = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedSupplier,
                            decoration: const InputDecoration(
                              labelText: 'Nhà cung cấp',
                              border: OutlineInputBorder(),
                            ),
                            items: dsNCC?.map((NhaCungCap supplier) {
                              return DropdownMenuItem<String>(
                                value: supplier.maNCC,
                                child: Text(supplier.tenNCC),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSupplier = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: slKhoController,
                            decoration: const InputDecoration(
                              labelText: 'Số lượng kho',
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true, // Set as read-only
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              saveChanges(context);
                            },
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
