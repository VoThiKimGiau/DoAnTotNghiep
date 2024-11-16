import 'package:datn_cntt304_bandogiadung/controllers/TTNhanHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/TTNhanHang.dart';
import 'package:datn_cntt304_bandogiadung/views/CaiDat/TTNhanHang.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import '../../colors/color.dart';

class AddDeliveryAddressScreen extends StatefulWidget {
  final String? maKH;

  AddDeliveryAddressScreen({required this.maKH});

  @override
  _AddDeliveryAddressScreenState createState() =>
      _AddDeliveryAddressScreenState();
}

class _AddDeliveryAddressScreenState extends State<AddDeliveryAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'phone': TextEditingController(),
    'houseNumber': TextEditingController(),
    'ward': TextEditingController(),
    'district': TextEditingController(),
    'city': TextEditingController(),
  };

  final Map<String, FocusNode> _focusNodes = {
    'name': FocusNode(),
    'phone': FocusNode(),
    'houseNumber': FocusNode(),
    'ward': FocusNode(),
    'district': FocusNode(),
    'city': FocusNode(),
  };

  final Map<String, Color> _borderColors = {
    'name': Colors.grey,
    'phone': Colors.grey,
    'houseNumber': Colors.grey,
    'ward': Colors.grey,
    'district': Colors.grey,
    'city': Colors.grey,
  };

  bool _isDefaultAddress = false;

  @override
  void initState() {
    super.initState();
    _focusNodes.forEach((key, node) {
      node.addListener(() {
        setState(() {
          _borderColors[key] =
              node.hasFocus ? AppColors.primaryColor : Colors.grey;
        });
      });
    });
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Thêm địa chỉ giao hàng',
            style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ..._buildTextFields(),
              Row(
                children: [
                  Checkbox(
                    value: _isDefaultAddress,
                    onChanged: (value) {
                      setState(() {
                        _isDefaultAddress = value!;
                      });
                    },
                  ),
                  const Text(
                    'Địa chỉ mặc định',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.maKH != null) {
                    _submitForm(widget.maKH!);
                  } else {
                    // Handle the case where maKH is null, if necessary
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Mã khách hàng không hợp lệ.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Lưu',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    final labels = [
      'Họ tên',
      'SĐT',
      'Số nhà',
      'Phường/Xã',
      'Quận/Huyện',
      'Thành phố/Tỉnh'
    ];
    return List.generate(labels.length, (index) {
      String key =
          ['name', 'phone', 'houseNumber', 'ward', 'district', 'city'][index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: _controllers[key],
          focusNode: _focusNodes[key],
          decoration: InputDecoration(
            labelText: labels[index],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _borderColors[key]!),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          inputFormatters:
              key == 'phone' ? [FilteringTextInputFormatter.digitsOnly] : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập ${labels[index]}';
            }
            if (key == 'phone') {
              // Validate phone number: must be 10 digits and start with 0
              final regex = RegExp(r'^0\d{9}$');
              if (!regex.hasMatch(value)) {
                return 'SĐT phải là 10 số và bắt đầu bằng 0';
              }
            }
            return null;
          },
        ),
      );
    });
  }

  Future<void> _submitForm(String maKH) async {
    if (_formKey.currentState!.validate()) {
      TTNhanHangController ttNhanHangController = TTNhanHangController();

      String address =
          '${_controllers['houseNumber']!.text}, ${_controllers['ward']!.text}, ${_controllers['district']!.text}, ${_controllers['city']!.text}';

      try {
        List<TTNhanHang> dsTT = await ttNhanHangController.getAllTTNhanHang();

        int getMaxID(List<TTNhanHang> dsTT) {
          int maxId = 0;
          for (TTNhanHang tt in dsTT) {
            if (tt.maTTNH!.startsWith('TT')) {
              int id = int.parse(tt.maTTNH!.substring(2));
              if (id > maxId) {
                maxId = id;
              }
            }
          }
          return maxId;
        }

        String generateTTNhanHangCode() {
          int currentMaxId = getMaxID(dsTT);
          currentMaxId++;
          return 'TT$currentMaxId';
        }

        await ttNhanHangController.createTTNhanHang(
          TTNhanHang(
            maTTNH: generateTTNhanHangCode(),
            hoTen: _controllers['name']!.text,
            diaChi: address,
            sdt: _controllers['phone']!.text,
            maKH: maKH,
            macDinh: _isDefaultAddress,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm địa chỉ thành công!')),
        );

        Navigator.pop(context);
      } catch (error) {
        print('Error adding delivery address: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Thêm địa chỉ thất bại. Vui lòng thử lại.')),
        );
      }
    }
  }
}
