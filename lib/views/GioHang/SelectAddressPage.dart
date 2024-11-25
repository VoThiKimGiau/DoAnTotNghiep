import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../config/IpConfig.dart';
import '../../controllers/GiaoHangController.dart';
import '../../controllers/TTNhanHangController.dart';
import '../../models/TTNhanHang.dart';

class SelectAddressPage extends StatefulWidget {
  final String? maKH; // Thêm mã khách hàng vào tham số
  final TTNhanHang selectedAddress;

  SelectAddressPage({
    required this.maKH, // Thay đổi để nhận mã khách hàng
    required this.selectedAddress,
    required List<TTNhanHang> shippingAddresses,
  });

  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  late TTNhanHang currentSelectedAddress; // Địa chỉ đã chọn
  final TTNhanHangController controller =
      TTNhanHangController(); // Khởi tạo controller
  List<TTNhanHang> shippingAddresses = []; // Danh sách địa chỉ nhận hàng
  List<TTNhanHang> dsTT = [];

  @override
  void initState() {
    super.initState();
    _loadShippingAddresses();
    getAllTTNH();
  }

  Future<void> _loadShippingAddresses() async {
    try {
      List<TTNhanHang> addresses =
          await controller.fetchTTNhanHangByCustomer(widget.maKH);

      setState(() {
        shippingAddresses = addresses;

        currentSelectedAddress = addresses.isNotEmpty
            ? addresses.firstWhere(
                (address) => address.macDinh == true,
                orElse: () => addresses.first,
              )
            : widget.selectedAddress;
      });
    } catch (e) {
      print('Error loading shipping addresses: $e');
      // Xử lý lỗi nếu cần
    }
  }

  Future<void> getAllTTNH() async {
    try {
      List<TTNhanHang> fetchItems = await controller.getAllTTNhanHang();
      setState(() {
        dsTT = fetchItems;
      });
    } catch (error) {
      print('Error adding delivery address: $error');
    }
  }

  int getMaxID(List<TTNhanHang> dsTTNH) {
    int maxId = 0;
    for (TTNhanHang tt in dsTTNH) {
      if (tt.maTTNH!.startsWith('TT')) {
        int id = int.parse(tt.maTTNH!.substring(2));
        if (id > maxId) {
          maxId = id;
        }
      }
    }
    return maxId;
  }

  String generateTTNhanHangCode(List<TTNhanHang> dsTTNH) {
    int currentMaxId = getMaxID(dsTTNH);
    currentMaxId++;
    return 'TT$currentMaxId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn địa chỉ nhận hàng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, currentSelectedAddress),
        ),
      ),
      body: shippingAddresses.isEmpty
          ? const Center(child: Text('No shipping addresses available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shippingAddresses.length + 1,
              itemBuilder: (context, index) {
                if (index == shippingAddresses.length) {
                  return ElevatedButton.icon(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Thêm địa chỉ mới',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _showAddressForm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  );
                }

                final address = shippingAddresses[index];
                final isSelected = address == currentSelectedAddress;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentSelectedAddress = address;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${address.hoTen} | ${address.sdt}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gabarito',
                              fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(address.diaChi),
                        const SizedBox(height: 8),
                        if (address.macDinh == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Mặc định',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _showAddressForm(context, address),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: const Text(
                            'Chỉnh sửa',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, currentSelectedAddress);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: AppColors.primaryColor,
          ),
          child: const Text(
            'Xác nhận',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressForm(BuildContext context,
      [TTNhanHang? address]) async {
    final isEditing = address != null;

    final nameController = TextEditingController(
      text: isEditing ? address.hoTen : '',
    );
    final phoneController = TextEditingController(
      text: isEditing ? address.sdt : '',
    );
    final addressController = TextEditingController(
      text: isEditing ? address.diaChi : '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String maKhachHang = widget.maKH ?? '';
                  String diaChi = addressController.text.trim();
                  String hoTenC = nameController.text.trim();
                  String sdtC = phoneController.text.trim();

                  // Kiểm tra số điện thoại
                  if (!RegExp(r'^0[0-9]{9}$').hasMatch(sdtC)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Thông báo'),
                          content: const Text(
                              'Số điện thoại không hợp lệ. Số điện thoại phải bắt đầu bằng 0 và có đủ 10 chữ số.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  GiaoHangController giaoHangController = GiaoHangController();
                  const String APIKEY =
                      '8AOpT7e0QxfGS0TLD08A4M66K80ioaXiwMU1zUUv9IY';
                  String toaDoDC = '';
                  try {
                    final coords1 =
                        await giaoHangController.getCoordinates(diaChi, APIKEY);
                    toaDoDC = '${coords1['latitude']},${coords1['longitude']}';

                    isEditing
                        ? await controller.updateTTNhanHang(
                            address.maTTNH,
                            new TTNhanHang(
                              maTTNH: address.maTTNH,
                              hoTen: hoTenC,
                              diaChi: diaChi,
                              sdt: sdtC,
                              maKH: maKhachHang,
                              macDinh: address.macDinh,
                              toaDo: toaDoDC,
                            ))
                        : await controller.createTTNhanHang(new TTNhanHang(
                            maTTNH: generateTTNhanHangCode(dsTT),
                            hoTen: hoTenC,
                            diaChi: diaChi,
                            sdt: sdtC,
                            maKH: maKhachHang,
                            macDinh: false,
                            toaDo: toaDoDC));

                    await _loadShippingAddresses();

                    Navigator.pop(context);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Thông báo'),
                          content: const Text(
                              'Địa chỉ không hợp lệ. Vui lòng thử lại'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text(
                  isEditing ? 'Cập nhật' : 'Thêm mới',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
