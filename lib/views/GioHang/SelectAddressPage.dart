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

  @override
  void initState() {
    super.initState();
    _loadShippingAddresses();
  }

  Future<void> _loadShippingAddresses() async {
    try {
      List<TTNhanHang> addresses =
          await controller.fetchTTNhanHangByCustomer(widget.maKH);

      shippingAddresses = addresses; // Cập nhật danh sách địa chỉ nhận hàng
    } catch (e) {
      print('Error loading shipping addresses: $e');
      // Xử lý lỗi nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn địa chỉ nhận hàng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, currentSelectedAddress),
        ),
      ),
      body: shippingAddresses.isEmpty
          ? Center(child: Text('No shipping addresses available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shippingAddresses.length + 1,
              itemBuilder: (context, index) {
                if (index == shippingAddresses.length) {
                  return ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Thêm địa chỉ mới'),
                    onPressed: () => _showAddressForm(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(address.diaChi),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _showAddressForm(context, address),
                          child: Text('Chỉnh sửa'),
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
          ),
          child: const Text('Xác nhận'),
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
                decoration: InputDecoration(labelText: 'Tên'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final newAddress = TTNhanHang(
                    maTTNH: isEditing
                        ? address.maTTNH
                        : DateTime.now().millisecondsSinceEpoch.toString(),
                    hoTen: nameController.text,
                    diaChi: addressController.text,
                    sdt: phoneController.text,
                    maKH: customerController.text,
                    // Sử dụng mã khách hàng hiện tại
                    macDinh: false,
                  );

                  setState(() {
                    if (isEditing) {
                      final index = shippingAddresses.indexOf(address);
                      shippingAddresses[index] = newAddress;
                    } else {
                      shippingAddresses.add(newAddress);
                    }
                  });

                  Navigator.pop(context);
                },
                child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
              ),
            ],
          ),
        );
      },
    );
  }
}
