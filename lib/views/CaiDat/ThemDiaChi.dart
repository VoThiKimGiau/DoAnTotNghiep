import 'package:datn_cntt304_bandogiadung/controllers/TTNhanHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/TTNhanHang.dart';
import 'package:datn_cntt304_bandogiadung/views/CaiDat/TTNhanHang.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:flutter_svg/svg.dart';
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 20, top: 40),
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
                        'THÊM THÔNG TIN NHẬN HÀNG',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [..._buildTextFields()],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Đặt làm địa chỉ mặc định',
                      style: TextStyle(fontSize: 18),
                    ),
                    Switch(
                      activeColor: Colors.deepOrange,
                      value: _isDefaultAddress,
                      onChanged: (value) {
                        setState(() {
                          _isDefaultAddress = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.maKH != null) {
                      _submitForm(widget.maKH!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Mã khách hàng không hợp lệ.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Lưu',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
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

        Navigator.pop(context, true);
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
