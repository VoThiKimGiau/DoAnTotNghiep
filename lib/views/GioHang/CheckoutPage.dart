import 'package:flutter/material.dart';

import 'SuccessPage.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount; // Thêm biến để nhận tổng tiền

  CheckoutPage({required this.totalAmount}); // Cập nhật constructor

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}


class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = 'Thanh toán khi nhận hàng';
  String selectedShippingMethod = 'Thường';
  String selectedPromoCode = '';
  List<String> promoCodes = ['Giảm tối đa \$30 ', 'Giảm 9%', 'Giảm tối đa \$70'];

  // Danh sách địa chỉ
  List<Map<String, String>> shippingAddresses = [
    {
      'name': 'Hoàng Minh',
      'address': '123 Lê Lợi, Quận 1, TPHCM',
      'phone': '+84 345 678 910',
    },
  ];

  Map<String, String> selectedAddress = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin nhận hàng
              GestureDetector(
                onTap: () => _showShippingAddresses(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thông tin nhận hàng",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    if (selectedAddress.isNotEmpty)
                      _buildInfoRow("Tên người nhận", selectedAddress['name']!),
                    if (selectedAddress.isNotEmpty)
                      _buildInfoRow("Địa chỉ", selectedAddress['address']!),
                    if (selectedAddress.isNotEmpty)
                      _buildInfoRow("Số điện thoại", selectedAddress['phone']!),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _addNewShippingInfo(context),
                      child: Text("Thêm địa chỉ nhận hàng mới"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Phương thức thanh toán
              Text(
                "Phương thức thanh toán",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPaymentMethodOptions(),

              SizedBox(height: 20),

              // Phương thức vận chuyển
              Text(
                "Phương thức vận chuyển",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildShippingMethodOptions(),

              SizedBox(height: 20),

              // Áp dụng mã khuyến mãi
              Text(
                "Áp dụng mã khuyến mãi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPromoCodeOptions(),

              SizedBox(height: 20),

              // Hiển thị tổng giá trị đơn hàng và nút xác nhận
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tổng cộng", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text("\$${widget.totalAmount.toStringAsFixed(2)}", style: TextStyle(fontSize: 18)), // Hiển thị tổng tiền
                ],
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SuccessPage()),
                  );
                },
                child: Text("Đặt hàng"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOptions() {
    return Column(
      children: [
        ListTile(
          title: const Text('Thanh toán khi nhận hàng'),
          leading: Radio<String>(
            value: 'Thanh toán khi nhận hàng',
            groupValue: selectedPaymentMethod,
            onChanged: (String? value) {
              setState(() {
                selectedPaymentMethod = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Thanh toán online'),
          leading: Radio<String>(
            value: 'Thanh toán online',
            groupValue: selectedPaymentMethod,
            onChanged: (String? value) {
              setState(() {
                selectedPaymentMethod = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShippingMethodOptions() {
    return Column(
      children: [
        ListTile(
          title: const Text('Thường'),
          leading: Radio<String>(
            value: 'Thường',
            groupValue: selectedShippingMethod,
            onChanged: (String? value) {
              setState(() {
                selectedShippingMethod = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Hỏa tốc'),
          leading: Radio<String>(
            value: 'Hỏa tốc',
            groupValue: selectedShippingMethod,
            onChanged: (String? value) {
              setState(() {
                selectedShippingMethod = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCodeOptions() {
    return Column(
      children: promoCodes.map((promoCode) {
        return ListTile(
          title: Text(promoCode),
          leading: Radio<String>(
            value: promoCode,
            groupValue: selectedPromoCode,
            onChanged: (String? value) {
              setState(() {
                selectedPromoCode = value!;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  // Hàm mở hộp thoại danh sách địa chỉ nhận hàng
  Future<void> _showShippingAddresses(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Danh sách địa chỉ nhận hàng'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: shippingAddresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(shippingAddresses[index]['name']!),
                  subtitle: Text(shippingAddresses[index]['address']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _editShippingInfo(context, index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Cập nhật selectedAddress nếu địa chỉ bị xóa là địa chỉ đã chọn
                          if (selectedAddress == shippingAddresses[index]) {
                            setState(() {
                              selectedAddress = {}; // Xóa thông tin địa chỉ nhận hàng đã chọn
                            });
                          }
                          setState(() {
                            shippingAddresses.removeAt(index);
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Cập nhật thông tin nhận hàng với địa chỉ đã chọn
                    setState(() {
                      selectedAddress = shippingAddresses[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm mở hộp thoại thêm địa chỉ mới
  Future<void> _addNewShippingInfo(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm địa chỉ nhận hàng mới'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Tên người nhận'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Địa chỉ'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                ),
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
              child: Text('Lưu'),
              onPressed: () {
                setState(() {
                  // Thêm địa chỉ mới vào danh sách
                  shippingAddresses.add({
                    'name': nameController.text,
                    'address': addressController.text,
                    'phone': phoneController.text,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm mở hộp thoại chỉnh sửa thông tin địa chỉ
  Future<void> _editShippingInfo(BuildContext context, int index) async {
    final TextEditingController nameController = TextEditingController(text: shippingAddresses[index]['name']);
    final TextEditingController addressController = TextEditingController(text: shippingAddresses[index]['address']);
    final TextEditingController phoneController = TextEditingController(text: shippingAddresses[index]['phone']);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sửa địa chỉ nhận hàng'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Tên người nhận'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Địa chỉ'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                ),
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
              child: Text('Lưu'),
              onPressed: () {
                setState(() {
                  // Cập nhật địa chỉ đã chọn
                  shippingAddresses[index] = {
                    'name': nameController.text,
                    'address': addressController.text,
                    'phone': phoneController.text,
                  };
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
