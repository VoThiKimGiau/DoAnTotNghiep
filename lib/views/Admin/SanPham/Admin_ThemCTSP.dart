import 'dart:convert';
import 'dart:io';
import 'package:datn_cntt304_bandogiadung/controllers/HinhAnhController.dart';
import 'package:datn_cntt304_bandogiadung/models/HinhAnhSP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:datn_cntt304_bandogiadung/models/KichCo.dart';
import '../../../controllers/MauSPController.dart';
import '../../../controllers/NhaCungCapController.dart';
import 'package:datn_cntt304_bandogiadung/models/MauSP.dart';

class AdminThemCTSP extends StatefulWidget {
  String maSP;

  AdminThemCTSP({required this.maSP});

  @override
  _AdminThemCTSPState createState() => _AdminThemCTSPState();
}

class _AdminThemCTSPState extends State<AdminThemCTSP> {
  final TextEditingController giaBanController = TextEditingController();
  String? selectedKichCo;
  String? selectedMau;
  String? selectedNhaCungCap;
  String? uploadedImageUrl;
  List<KichCo>? dsKichCo;
  List<MauSP>? dsMau;
  List<NhaCungCap>? dsNhaCungCap;

  ChiTietSPController chiTietSPController = ChiTietSPController();
  NCCController nhaCungCapController = NCCController();
  KichCoController kichCoController = KichCoController();
  MauSPController mauController = MauSPController();
  HinhAnhController hinhAnhController = HinhAnhController();

  int? newID;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([
      fetchKichCo(),
      fetchMau(),
      fetchNhaCungCap(),
      fetchNewID(),
    ]);
  }

  Future<void> fetchNewID() async {
    try {
      int fetchItems = await chiTietSPController.fetchSLCTSP();
      setState(() {
        newID = fetchItems + 1;
      });
    } catch (e) {
      setState(() {
        newID = null;
      });
    }
  }

  Future<void> fetchKichCo() async {
    try {
      dsKichCo = await kichCoController.fetchAllKichCo();
    } catch (e) {
      print('Error fetching sizes: $e');
    }
  }

  Future<void> fetchMau() async {
    try {
      dsMau = await mauController.fetchAllMauSP();
    } catch (e) {
      print('Error fetching colors: $e');
    }
  }

  Future<void> fetchNhaCungCap() async {
    try {
      dsNhaCungCap = await nhaCungCapController.fetchSuppliers();
    } catch (e) {
      print('Error fetching suppliers: $e');
    }
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String fileName = 'HA$newID.jpg';
      final FirebaseStorage storage = FirebaseStorage.instance;

      try {
        await storage.ref(fileName).putFile(File(image.path));

        String downloadUrl = await storage.ref(fileName).getDownloadURL();
        await hinhAnhController.createImage(
            new HinhAnhSP(maHinhAnh: 'HA$newID', lienKetURL: downloadUrl));

        setState(() {
          uploadedImageUrl = 'HA$newID';
        });
        _showErrorDialog('Tải hình ảnh lên thành công!', 'Thông báo');
      } catch (e) {
        print('Error uploading image: $e');
        _showErrorDialog('Tải hình ảnh lên thất bại', 'Lỗi');
      }
    }
  }

  Future<void> _saveChiTietSP() async {
    try {
      ChiTietSP newCTSP = ChiTietSP(
        maCTSP: 'CTSP$newID' ?? '',
        maSP: widget.maSP,
        maKichCo: selectedKichCo ?? '',
        maMau: selectedMau ?? '',
        giaBan: double.tryParse(giaBanController.text) ?? 0,
        maHinhAnh: uploadedImageUrl ?? 'HA0',
        maNCC: selectedNhaCungCap ?? '',
        slKho: 0,
      );

      await chiTietSPController.addChiTietSP(newCTSP);
      Navigator.of(context).pop(true);
    } catch (e) {
      _showErrorDialog(
          'Thêm chi tiết sản phẩm thất bại. Vui lòng thử lại!', 'Lỗi');
    }
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

  void _addKichCo() {
    String newKichCo = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm kích cỡ mới'),
          content: TextField(
            onChanged: (value) {
              newKichCo = value;
            },
            decoration: const InputDecoration(labelText: 'Nhập tên kích cỡ'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                if (newKichCo.isNotEmpty) {
                  // Thêm kích cỡ mới vào cơ sở dữ liệu
                  int newKC = dsKichCo?.length ?? 0;
                  await kichCoController.addKichCo(new KichCo(
                      tenKichCo: newKichCo, maKichCo: 'KC${newKC + 1}'));

                  // Cập nhật danh sách kích cỡ
                  fetchKichCo();

                  // Đóng dialog
                  Navigator.of(context).pop();
                  _showErrorDialog('Thêm kích cỡ thành công!', 'Thông báo');
                } else {
                  _showErrorDialog('Tên kích cỡ không được để trống!', 'Lỗi');
                }
              },
              child: const Text('Xác Nhận'),
            ),
          ],
        );
      },
    );
  }

  void _addMau() {
    String newTenMau = '';
    Color newColor = Colors.blue; // Màu mặc định

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm Màu Mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    newTenMau = value; // Lưu tên màu mới
                  },
                  decoration: const InputDecoration(labelText: 'Tên màu'),
                ),
                const SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Mã HEX',
                    hintText:
                        '#${newColor.value.toRadixString(16).substring(2, 8)}',
                    // Hiển thị mã HEX
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.color_lens),
                      onPressed: () {
                        // Mở ColorPicker
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Chọn màu'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: newColor,
                                  onColorChanged: (Color color) {
                                    setState(() {
                                      newColor = color; // Cập nhật màu đã chọn
                                    });
                                  },
                                  showLabel: true,
                                  pickerAreaHeightPercent: 0.8,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Chọn'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Đóng dialog ColorPicker
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: const Text('Xác Nhận'),
              onPressed: () async {
                if (newTenMau.isNotEmpty) {
                  int idMau = dsMau?.length ?? 0;
                  MauSP newMauSP = MauSP(
                    maMau: 'MM${idMau + 1}',
                    tenMau: newTenMau,
                    maHEX:
                        '#${newColor.value.toRadixString(16).substring(2, 8)}',
                  );

                  await mauController.addMauSP(newMauSP);

                  await fetchMau();

                  Navigator.of(context).pop();
                  _showErrorDialog('Thêm màu thành công!', 'Thông báo');
                } else {
                  _showErrorDialog('Vui lòng điền đầy đủ thông tin!', 'Lỗi');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addNhaCungCap() {
    String newTenNCC = '';
    String newSDT = '';
    String newEmail = '';
    String newDiaChi = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm Nhà Cung Cấp Mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    newTenNCC = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Tên nhà cung cấp'),
                ),
                TextField(
                  onChanged: (value) {
                    newSDT = value;
                  },
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  onChanged: (value) {
                    newEmail = value;
                  },
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  onChanged: (value) {
                    newDiaChi = value;
                  },
                  decoration: const InputDecoration(labelText: 'Địa chỉ'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                if (newTenNCC.isNotEmpty &&
                    newSDT.isNotEmpty &&
                    newEmail.isNotEmpty &&
                    newDiaChi.isNotEmpty) {
                  int idNCC = dsNhaCungCap?.length ?? 0;
                  NhaCungCap newNCC = NhaCungCap(
                    maNCC: 'NCC${idNCC + 1}',
                    tenNCC: newTenNCC,
                    sdt: newSDT,
                    email: newEmail,
                    diaChi: newDiaChi,
                  );

                  await nhaCungCapController.createNhaCungCap(newNCC);

                  fetchNhaCungCap();

                  Navigator.of(context).pop();
                  _showErrorDialog(
                      'Thêm nhà cung cấp thành công!', 'Thông báo');
                } else {
                  _showErrorDialog('Vui lòng điền đầy đủ thông tin!', 'Lỗi');
                }
              },
              child: const Text('Xác Nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thêm chi tiết sản phẩm',
            style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: giaBanController,
                decoration: const InputDecoration(labelText: 'Giá bán'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedKichCo,
                      decoration: const InputDecoration(
                        labelText: 'Kích cỡ',
                        border: OutlineInputBorder(),
                      ),
                      items: dsKichCo?.map((KichCo kc) {
                        return DropdownMenuItem<String>(
                          value: kc.maKichCo.trim(),
                          child: Text(kc.tenKichCo),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedKichCo = newValue;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addKichCo,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedMau,
                      decoration: const InputDecoration(
                        labelText: 'Màu sắc',
                        border: OutlineInputBorder(),
                      ),
                      items: dsMau?.map((MauSP mau) {
                        return DropdownMenuItem<String>(
                          value: mau.maMau.trim(),
                          child: Text(mau.tenMau),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMau = newValue;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addMau,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedNhaCungCap,
                      decoration: const InputDecoration(
                        labelText: 'Nhà cung cấp',
                        border: OutlineInputBorder(),
                      ),
                      items: dsNhaCungCap?.map((NhaCungCap ncc) {
                        return DropdownMenuItem<String>(
                          value: ncc.maNCC.trim(),
                          child: Text(ncc.tenNCC),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedNhaCungCap = newValue;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addNhaCungCap,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text('Tải hình ảnh lên',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChiTietSP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text('Lưu chi tiết sản phẩm',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
