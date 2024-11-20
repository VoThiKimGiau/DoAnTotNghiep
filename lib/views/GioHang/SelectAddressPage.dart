import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../config/IpConfig.dart';
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
          child: const Text('Xác nhận', style: TextStyle(color: Colors.white),),
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
    final customerController = TextEditingController(
      text: isEditing ? address.maKH : '',
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
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  isEditing
                      ? await controller.updateTTNhanHangByCustomer(
                          address.maTTNH,
                          nameController.text,
                          addressController.text,
                          widget.maKH,
                          phoneController.text,
                        )
                      : await controller.createTTNhanHangByCustomer(
                          generateTTNhanHangCode(dsTT),
                          nameController.text,
                          addressController.text,
                          widget.maKH,
                          phoneController.text,
                        );

                  await _loadShippingAddresses();

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text(isEditing ? 'Cập nhật' : 'Thêm mới', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      },
    );
  }
}
