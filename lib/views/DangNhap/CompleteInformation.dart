import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/main.dart';
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CompleteInformation extends StatefulWidget {
  final String maKH;
  final String tenKH;
  final String sdt;
  final String email;
  final String tenTK;
  final String matKhau;

  CompleteInformation({
    required this.maKH,
    required this.tenKH,
    required this.sdt,
    required this.email,
    required this.tenTK,
    required this.matKhau,
  });

  @override
  _CompleteInformationState createState() => _CompleteInformationState();
}

class _CompleteInformationState extends State<CompleteInformation> {
  DateTime? _selectedDate;
  String? _selectedGender = 'Nam';
  KhachHangController khachHangController = KhachHangController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _createAccount() {
    bool gTinh = _selectedGender == 'Nam' ? false : true;

    khachHangController.insertCustomer(new KhachHang(
      maKH: widget.maKH,
      tenKH: widget.tenKH,
      sdt: widget.sdt,
      email: widget.email,
      tenTK: widget.tenTK,
      matKhau: widget.matKhau,
      hoatDong: true,
      gioiTinh: gTinh,
      ngaySinh: _selectedDate,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã tạo tài khoản thành công'),
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String displayDate = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : DateFormat('dd/MM/yyyy').format(DateTime.now());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(
                            left: 27, top: 63, bottom: 24),
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
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Thông tin về bạn',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50.0, left: 20.0),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bạn là?',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedGender = 'Nam';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedGender == 'Nam'
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              foregroundColor: _selectedGender == 'Nam'
                                  ? Colors.white
                                  : Colors.black,
                              minimumSize: const Size(161, 50),
                            ),
                            child: const Text('Nam'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedGender = 'Nữ';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedGender == 'Nữ'
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              foregroundColor: _selectedGender == 'Nữ'
                                  ? Colors.white
                                  : Colors.black,
                              minimumSize: const Size(161, 50),
                            ),
                            child: const Text('Nữ'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50.0, left: 20.0),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ngày sinh của bạn?',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            displayDate,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                            ),
                            child: const Text(
                              'Chọn Ngày',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ElevatedButton(
                onPressed: _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Tạo tài khoản'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
