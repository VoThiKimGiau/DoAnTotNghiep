import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/CreateNewPassword.dart';
import 'package:flutter/material.dart';

class RegeneratePassword extends StatefulWidget {
  final String? maKH;
  final String? code;

  RegeneratePassword({required this.maKH, required this.code});

  @override
  _RegeneratePassword createState() => _RegeneratePassword();
}

class _RegeneratePassword extends State<RegeneratePassword> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 200.0),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/images/send_mail.png'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24.0),
                child: const Text(
                  'Chúng tôi đã gửi mã code qua email của bạn',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Vui lòng nhập mã code',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (_codeController.text.trim() == widget.code) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateNewPasswordScreen(maKH: widget.maKH),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mã code không đúng, vui lòng kiểm tra lại.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Tiếp tục'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}