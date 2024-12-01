import 'dart:io';
import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DanhMucSPController.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AdminSuaDM extends StatefulWidget {
  final String maDanhMuc;

  AdminSuaDM({required this.maDanhMuc});

  @override
  _AdminSuaDMState createState() => _AdminSuaDMState();
}

class _AdminSuaDMState extends State<AdminSuaDM> {
  DanhMucSPController danhMucSPController = DanhMucSPController();
  DanhMucSP? itemDanhMuc;
  bool isLoading = true;
  final TextEditingController tenDanhMucController = TextEditingController();
  String? imageUrl;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    fetchDanhMucSP();
  }

  Future<void> fetchDanhMucSP() async {
    try {
      DanhMucSP? fetchItem = await danhMucSPController.getDanhMucById(widget.maDanhMuc);
      if (fetchItem != null) {
        setState(() {
          itemDanhMuc = fetchItem;
          tenDanhMucController.text = fetchItem.tenDanhMuc;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching DanhMucSP: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh mục. Vui lòng thử lại.')),
      );
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    if (itemDanhMuc != null) {
      try {
        DanhMucSP updatedDM = DanhMucSP(
          maDanhMuc: itemDanhMuc!.maDanhMuc,
          tenDanhMuc: tenDanhMucController.text,
          anhDanhMuc: imageUrl ?? itemDanhMuc!.anhDanhMuc,
        );

        await danhMucSPController.updateDanhMucSP(updatedDM.maDanhMuc, updatedDM);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật danh mục thành công')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        print('Error saving changes: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi cập nhật. Vui lòng kiểm tra lại')),
        );
      }
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _imageFile = pickedFile;
    });

    String newFileName = 'A${widget.maDanhMuc}.jpg';
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
        fetchDanhMucSP();
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
                        'SỬA DANH MỤC',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  children: [
                    if (itemDanhMuc?.anhDanhMuc != null && itemDanhMuc!.anhDanhMuc.isNotEmpty)
                      Image.network(
                        itemDanhMuc!.anhDanhMuc,
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _uploadImage(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                        'Tải hình ảnh lên',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: tenDanhMucController,
                      decoration: const InputDecoration(
                        labelText: 'Tên danh mục',
                        border: OutlineInputBorder(),
                      ),
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
                        style: TextStyle(color: Colors.white, fontSize: 16),
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