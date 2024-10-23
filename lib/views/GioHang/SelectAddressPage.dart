import 'package:flutter/material.dart';

class SelectAddressPage extends StatefulWidget {
  final List<Map<String, String>> shippingAddresses;
  final Map<String, String> selectedAddress;

  SelectAddressPage({
    required this.shippingAddresses,
    required this.selectedAddress,
  });

  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  late Map<String, String> currentSelectedAddress;

  @override
  void initState() {
    super.initState();
    currentSelectedAddress = widget.selectedAddress;
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.shippingAddresses.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.shippingAddresses.length) {
            return ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Thêm địa chỉ mới'),
              onPressed: () => _showAddressForm(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            );
          }

          final address = widget.shippingAddresses[index];
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
                    '${address['name']} | ${address['phone']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(address['address']!),
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
          child: Text('Xác nhận'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressForm(BuildContext context,
      [Map<String, String>? address]) async {
    final isEditing = address != null;

    final nameController = TextEditingController(
      text: isEditing ? address!['name'] : '',
    );
    final phoneController = TextEditingController(
      text: isEditing ? address!['phone'] : '',
    );
    final addressController = TextEditingController(
      text: isEditing ? address!['address'] : '',
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
                  final newAddress = {
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'address': addressController.text,
                  };

                  setState(() {
                    if (isEditing) {
                      final index =
                      widget.shippingAddresses.indexOf(address!);
                      widget.shippingAddresses[index] = newAddress;
                    } else {
                      widget.shippingAddresses.add(newAddress);
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
