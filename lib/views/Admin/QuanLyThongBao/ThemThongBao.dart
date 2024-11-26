import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ThongBaoController.dart';
import 'package:datn_cntt304_bandogiadung/models/ThongBao.dart';

class AddNotificationScreen extends StatefulWidget {
  @override
  _AddNotificationScreenState createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ThongBaoController _thongBaoController = ThongBaoController();
  String _noiDung = '';

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      primary: Colors.blue,
      secondary: Colors.orange,
      surface: Colors.white,
      background: Colors.grey[100]!,
      error: Colors.red,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm thông báo mới'),
        backgroundColor: colorScheme.primary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nội dung thông báo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung thông báo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _noiDung = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Thêm thông báo'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addNotification();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNotification() async {
    try {
      ThongBao newThongBao = ThongBao(
        maTB: '', // Generate a unique ID
        noiDung: _noiDung,
        ngayTB: DateTime.now(),
      );

      ThongBao createdThongBao = await _thongBaoController.createThongBao(newThongBao);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thông báo đã được thêm thành công')),
      );
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      print('Error adding notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi thêm thông báo')),
      );
    }
  }
}

