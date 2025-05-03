import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhachHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/KhachHang.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/CompleteInformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  KhachHangController khachHangController = KhachHangController();
  List<KhachHang>? dsKH;

  final TextEditingController tenKHController = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tenTKController = TextEditingController();
  final TextEditingController matKhauController = TextEditingController();
  final TextEditingController nhapLaiMatKhauController =
      TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    fetchKH();
  }

  Future<void> fetchKH() async {
    try {
      List<KhachHang> fetchedItems =
          await khachHangController.fetchAllCustomer();
      setState(() {
        dsKH = fetchedItems;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        dsKH = [];
      });
    }
  }

  int getMaxID(List<KhachHang> dsKH) {
    int maxId = 0;
    for (KhachHang kh in dsKH) {
      if (kh.maKH!.startsWith('KH')) {
        int id = int.parse(kh.maKH!.substring(2));
        if (id > maxId) {
          maxId = id;
        }
      }
    }
    return maxId;
  }

  String generateCustomerCode() {
    int currentMaxId = getMaxID(dsKH!);
    currentMaxId++;
    return 'KH$currentMaxId';
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  // bool checkPassInHoa(String pass){
  //   final regex = RegExp(r'[A-Z]');
  //   return regex.hasMatch(pass);
  // }

  // bool checkPassDB(String pass){
  //   final regex = RegExp(r'!@#$%^&*');
  //   return regex.hasMatch(pass);
  // }

  @override
  void dispose() {
    tenKHController.dispose();
    sdtController.dispose();
    emailController.dispose();
    tenTKController.dispose();
    matKhauController.dispose();
    nhapLaiMatKhauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(left: 27, top: 63, bottom: 24),
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
              const Center(
                child: Text(
                  'Tạo tài khoản',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 28.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: tenKHController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Họ và tên',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: sdtController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Số điện thoại',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (value) {
                        if (value.length == 1 && value != '0') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Số điện thoại phải bắt đầu bằng 0!'),
                            ),
                          );
                        }
                      },
                      onSubmitted: (value) {
                        if (value.length != 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Số điện thoại phải có đúng 10 số và bắt đầu bằng 0!'),
                            ),
                          );
                        } else if (!value.startsWith('0')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Số điện thoại phải bắt đầu bằng 0!'),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: tenTKController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Tên tài khoản',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: matKhauController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Mật khẩu',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(showPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: !showPassword,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nhapLaiMatKhauController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Nhập lại mật khẩu',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: !showConfirmPassword,
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 40),
                child: ElevatedButton(
                  onPressed: () {
                    String tenKH = tenKHController.text.trim();
                    String sdt = sdtController.text.trim();
                    String email = emailController.text.trim();
                    String tenTK = tenTKController.text.trim();
                    String matKhau = matKhauController.text.trim();
                    String nhapLaiMatKhau = nhapLaiMatKhauController.text.trim();

                    if (tenKH.isEmpty || sdt.isEmpty || email.isEmpty || tenTK.isEmpty || matKhau.isEmpty || nhapLaiMatKhau.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui lòng điền tất cả các thông tin!'),
                        ),
                      );
                      return;
                    }

                    if (sdt.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Số điện thoại phải có đúng 10 số!'),
                        ),
                      );
                      return;
                    }

                    // if(!checkPassInHoa(matKhau) ){
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Mật khẩu phải có kí tự in hoa'),
                    //     ),
                    //   );
                    //   return;
                    // }

                    // if(!checkPassDB(matKhau) ){
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Mật khẩu phải có kí tự đặc biệt'),
                    //     ),
                    //   );
                    //   return;
                    // }

                    for(KhachHang kh in dsKH!){
                      if(kh.tenTK == tenTK.trim())
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tên tài khoản đã có người sử dụng vui lòng nhập lại tên khác.'),
                            ),
                          );
                          return;
                        }

                      if(kh.sdt == sdt.trim())
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Số điện thoại này đã có tài khoản. Vui lòng kiểm tra lại'),
                          ),
                        );
                        return;
                      }

                      if(kh.email == email.trim())
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email này đã có tài khoản. Vui lòng kiểm tra lại'),
                          ),
                        );
                        return;
                      }
                    }

                    if (!isValidEmail(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email không hợp lệ! Vui lòng nhập lại.'),
                        ),
                      );
                      return;
                    }

                    if (matKhau.length < 8 || matKhau.length > 30) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Mật khẩu phải có ít nhất 8 ký tự và nhiều nhất 30 ký tự!'),
                        ),
                      );
                      return;
                    }

                    if (matKhau == nhapLaiMatKhau) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompleteInformation(
                                  maKH: generateCustomerCode(),
                                  tenKH: tenKH,
                                  sdt: sdt,
                                  email: email,
                                  tenTK: tenTK,
                                  matKhau: matKhau)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Mật khẩu không khớp! Vui lòng kiểm tra lại'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Tiếp tục',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
