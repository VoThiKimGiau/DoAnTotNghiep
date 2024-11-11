import 'dart:io';
import 'package:datn_cntt304_bandogiadung/views/DonHang/ChiTietDonHang.dart';
import 'package:datn_cntt304_bandogiadung/views/DonHang/TBTraHang.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../controllers/DoiTraController.dart';
import '../../controllers/VatChungDoiTraController.dart';
import '../../dto/ChiTietDoiTraDTO.dart';
import '../../dto/DoiTraDTO.dart';
import '../../models/ChiTietDoiTra.dart';
import '../../models/DoiTra.dart';
import '../../models/DonHang.dart';
import '../../models/VatChungDoiTra.dart';
import '../../services/storage/storage_service.dart';
// Import other necessary packages and files

class MultiImageCaptureAndUpload extends StatefulWidget {
  final DoiTraDTO doiTraDTO;
  final DonHang donHang;

  const MultiImageCaptureAndUpload({
    Key? key,
    required this.doiTraDTO,
    required this.donHang,
  }) : super(key: key);

  @override
  _MultiImageCaptureAndUploadState createState() => _MultiImageCaptureAndUploadState();
}

class _MultiImageCaptureAndUploadState extends State<MultiImageCaptureAndUpload> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final VatChungDoiTraController _vatChungController = VatChungDoiTraController();
  final StorageService _storageService = StorageService();

  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];
  String _reason = "";
  String _accountNumber = "";
  String _bankName = "";
  String _accountName = "";
  bool _isLoading = false;
  DoiTra? doiTra;

  static const int maxImages = 5;

  @override
  void dispose() {
    _reasonController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vật chứng đổi trả'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _reasonController,
                    onChanged: (text) => setState(() => _reason = text),
                    decoration: InputDecoration(
                      labelText: 'Nhập lý do sản phẩm lỗi',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: _selectedImages.isNotEmpty
                        ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_selectedImages[index], fit: BoxFit.cover),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    )
                        : Center(child: Text('Không có ảnh nào được chọn!')),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _selectedImages.length < maxImages ? _pickMultipleImages : null,
                          icon: Icon(Icons.photo_library),
                          label: Text('Gallery'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _selectedImages.length < maxImages ? _captureMultiplePhotos : null,
                          icon: Icon(Icons.camera_alt),
                          label: Text('Camera'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showBankAccountDialog,
                    child: Text('Nhập Thông Tin Nhận Tiền Hoàn Trả'),
                  ),
                  if (_accountNumber.isNotEmpty || _bankName.isNotEmpty || _accountName.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông Tin Tài Khoản Ngân Hàng:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            if (_accountNumber.isNotEmpty)
                              Text('Số tài khoản: $_accountNumber'),
                            if (_bankName.isNotEmpty)
                              Text('Tên ngân hàng: $_bankName'),
                            if (_accountName.isNotEmpty)
                              Text('Tên tài khoản: $_accountName'),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadImagesAndCreateDoiTra,
                    child: Text('Gửi yêu cầu đổi trả'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickMultipleImages() async {
    if (_selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can select up to $maxImages images only.')),
      );
      return;
    }

    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images.map((xfile) => File(xfile.path)).toList());
        if (_selectedImages.length > maxImages) {
          _selectedImages = _selectedImages.sublist(0, maxImages);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Only the first $maxImages images were added.')),
          );
        }
      });
    }
  }

  Future<void> _captureMultiplePhotos() async {
    if (_selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have reached the maximum of $maxImages images.')),
      );
      return;
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImages.add(File(photo.path));
      });
    }
  }

  Future<void> _uploadImagesAndCreateDoiTra() async {
    if (_reasonController.text.isEmpty ||
        _accountNumberController.text.isEmpty ||
        _bankNameController.text.isEmpty ||
        _accountNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn ít nhất 1 ảnh')),
      );
      return;
    }

    await _showConfirmationDialog();
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận gửi yêu cầu đổi trả'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn gửi yêu cầu đổi trả này không?'),
                SizedBox(height: 10),
                Text('Số lượng ảnh: ${_selectedImages.length}'),
                Text('Lý do: ${_reasonController.text}'),
                Text('Số tài khoản: $_accountNumber'),
                Text('Tên ngân hàng: $_bankName'),
                Text('Tên tài khoản: $_accountName'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xác nhận'),
              onPressed: () {
                Navigator.of(context).pop();
                _processDoiTra();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _processDoiTra() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create DoiTra object
      final doiTra = DoiTra(
        maDoiTra: 'DT0',
        donHang: widget.donHang.maDH ?? '',
        lyDo: _reasonController.text,
        ngayDoiTra: DateTime.now(),
        ngayXacNhan:DateTime.now(),
        ngayHoanTien: DateTime.now(),
        ngayTraHang: DateTime.now(),
        trangThai: 'Chờ xác nhận',
        tenTK: _accountNameController.text,
        soTK: _accountNumberController.text,
        tenNganHang: _bankNameController.text,
        tienHoanTra: widget.doiTraDTO.tongTien ?? 0,
      );

      // Create DoiTra record and get the generated maDoiTra
      String? maDoiTra = await createDoiTra(doiTra);
      if (maDoiTra == null || maDoiTra.isEmpty) {
        throw Exception('Generated maDoiTra is null or empty');
      }

      List<String> uploadedImageUrls = [];

      for (File image in _selectedImages) {
        // Create VatChungDoiTra
        VatChungDoiTra vatChung = VatChungDoiTra(
          maVatChung: '',
          maDoiTra: maDoiTra,
          lienKetURL: '',
        );

        // Save VatChungDoiTra and get the generated maVatChung
        VatChungDoiTra createdVatChung = await _vatChungController.createVatChungDoiTra(vatChung);
        if (createdVatChung.maVatChung.isEmpty) {
          throw Exception('Generated maVatChung is empty');
        }

        // Upload image to Firebase using the generated maVatChung
        String imageUrl = await _storageService.uploadImage(image, createdVatChung.maVatChung);
        if (imageUrl.isEmpty) {
          throw Exception('Uploaded image URL is empty');
        }

        uploadedImageUrls.add(imageUrl);
      }

      // Create ChiTietDoiTra records
      for (ChiTietDoiTraDTO chiTietDTO in widget.doiTraDTO.chiTietDoiTras) {
        ChiTietDoiTra chiTietDoiTra = ChiTietDoiTra(
          maDoiTra: maDoiTra,
          maCTSP: chiTietDTO.maCTSP ?? '',
          gia: chiTietDTO.gia ?? 0,
          soluong: chiTietDTO.soLuong ?? 0,
        );
        await createChiTietDoiTra(chiTietDoiTra);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yêu cầu đổi trả đã được gửi thành công')),
      );

      // Navigate back or to a confirmation screen
      Navigator.of(context).pop();
    } catch (e) {
      print('Error in _processDoiTra: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
     // Navigator.push(context,MaterialPageRoute(builder: (context)=>TBTraHangScreen(maKH: widget.donHang.khachHang)) );
    }
  }

  Future<String?> createDoiTra(DoiTra doiTra) async {
    try {
      DoiTraController doiTraController = DoiTraController();
      DoiTra createdDoiTra = await doiTraController.createDoiTra(doiTra);
      return createdDoiTra.maDoiTra;
    } catch (error) {
      print('Failed to create DoiTra: $error');
      throw Exception('Error creating DoiTra: $error');
    }
  }

  Future<void> createChiTietDoiTra(ChiTietDoiTra chiTietDoiTra) async {
    try {
      DoiTraController doiTraController = DoiTraController();
      await doiTraController.createChiTietDoiTra(chiTietDoiTra);
    } catch (error) {
      print('Failed to create ChiTietDoiTra: $error');
      throw Exception('Error creating ChiTietDoiTra: $error');
    }
  }

  void _showBankAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhập Thông Tin Tài Khoản Ngân Hàng'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _accountNumberController,
                  decoration: InputDecoration(
                    labelText: 'Số tài khoản',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _bankNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên ngân hàng',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _accountNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên tài khoản',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _accountNumber = _accountNumberController.text;
                  _bankName = _bankNameController.text;
                  _accountName = _accountNameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Xác Nhận'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }


}