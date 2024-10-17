import 'package:datn_cntt304_bandogiadung/assets/colors/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddDeliveryAddressScreen(),
    );
  }
}

class AddDeliveryAddressScreen extends StatefulWidget {
  @override
  _AddDeliveryAddressScreenState createState() => _AddDeliveryAddressScreenState();
}

class _AddDeliveryAddressScreenState extends State<AddDeliveryAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wardController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _houseNumberController = TextEditingController();

  // Create focus nodes for each text form field
  final FocusNode _wardFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _districtFocusNode = FocusNode();
  final FocusNode _houseNumberFocusNode = FocusNode();

  Color _wardBorderColor = Colors.grey;
  Color _cityBorderColor = Colors.grey;
  Color _districtBorderColor = Colors.grey;
  Color _houseNumberBorderColor = Colors.grey;

  @override
  void initState() {
    super.initState();

    // Add listeners to change the border color when focused/unfocused
    _wardFocusNode.addListener(() {
      setState(() {
        _wardBorderColor = _wardFocusNode.hasFocus ? AppColors.primaryColor : Colors.grey;
      });
    });
    _cityFocusNode.addListener(() {
      setState(() {
        _cityBorderColor = _cityFocusNode.hasFocus ? AppColors.primaryColor : Colors.grey;
      });
    });
    _districtFocusNode.addListener(() {
      setState(() {
        _districtBorderColor = _districtFocusNode.hasFocus ? AppColors.primaryColor : Colors.grey;
      });
    });
    _houseNumberFocusNode.addListener(() {
      setState(() {
        _houseNumberBorderColor = _houseNumberFocusNode.hasFocus ? AppColors.primaryColor : Colors.grey;
      });
    });
  }

  @override
  void dispose() {
    _wardController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _houseNumberController.dispose();
    _wardFocusNode.dispose();
    _cityFocusNode.dispose();
    _districtFocusNode.dispose();
    _houseNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Thêm địa chỉ giao hàng',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(_wardController, 'Phường/Xã', _wardFocusNode, _wardBorderColor),
              SizedBox(height: 16),
              _buildTextFormField(_cityController, 'Thành phố/Tỉnh', _cityFocusNode, _cityBorderColor),
              SizedBox(height: 16),
              _buildTextFormField(_districtController, 'Quận/Huyện', _districtFocusNode, _districtBorderColor),
              SizedBox(height: 16),
              _buildTextFormField(_houseNumberController, 'Số nhà', _houseNumberFocusNode, _houseNumberBorderColor),
              Spacer(),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Lưu', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, FocusNode focusNode, Color borderColor) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the form data
      print('Ward: ${_wardController.text}');
      print('City: ${_cityController.text}');
      print('District: ${_districtController.text}');
      print('House Number: ${_houseNumberController.text}');
      // You can add your logic here to save the address
      Navigator.of(context).pop();
    }
  }
}
