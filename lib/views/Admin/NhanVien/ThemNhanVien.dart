import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/models/NhanVien.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhanVienController.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final NhanVienController _controller = NhanVienController();

  String _tenNV = '';
  String _sdt = '';
  String _email = '';
  String _chucVu = 'QUAN_LY';
  String _tenTK = '';
  String _matKhau = '';

  final List<String> _chucVuOptions = ['QUAN_LY', 'BAN_HANG','THU_KHO'];

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    primary: Colors.blue,
    secondary: Colors.orange,
    surface: Colors.white,
    background: Colors.grey[100]!,
    error: Colors.red,
  );

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newEmployee = NhanVien(
        maNV: '',
        tenNV: _tenNV,
        sdt: _sdt,
        email: _email,
        chucVu: _chucVu,
        tenTK: _tenTK,
        matKhau: _matKhau,
        hoatDong: true,
      );


      try {
        final response = await _controller.registerEmployee(newEmployee);
        if (response.statusCode == 201) {
          Navigator.pop(context, true);
        } else {
          _showSnackBar('Failed to add employee. Please try again.');
        }
      } catch (e) {
        _showSnackBar('Error adding employee: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Employee'),
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                  onSaved: (value) => _tenNV = value!,
                ),
                DropdownButtonFormField<String>(
                  value: _chucVu,
                  decoration: InputDecoration(labelText: 'Position'),
                  items: _chucVuOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _chucVu = newValue!;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
                  onSaved: (value) => _tenTK = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) => value!.isEmpty || value.length < 6 ? 'Password must be at least 6 characters' : null,
                  onSaved: (value) => _matKhau = value!,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Add Employee'),
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: colorScheme.background,
    );
  }
}

