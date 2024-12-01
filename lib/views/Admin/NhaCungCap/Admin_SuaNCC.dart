import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';

import '../../../controllers/NhaCungCapController.dart';

class AdminSuaNCC extends StatefulWidget {
  final String maNCC;

  AdminSuaNCC({required this.maNCC});

  @override
  _AdminSuaNCCState createState() => _AdminSuaNCCState();
}

class _AdminSuaNCCState extends State<AdminSuaNCC> {
  NCCController nccController = NCCController();
  NhaCungCap? itemNCC;
  bool isLoading = true;
  final TextEditingController tenNCCController = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController diaChiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNhaCungCap();
  }

  Future<void> fetchNhaCungCap() async {
    try {
      NhaCungCap? fetchItem = await nccController.fetchSupById(widget.maNCC);
      if (fetchItem != null) {
        setState(() {
          itemNCC = fetchItem;
          tenNCCController.text = fetchItem.tenNCC;
          sdtController.text = fetchItem.sdt;
          emailController.text = fetchItem.email;
          diaChiController.text = fetchItem.diaChi;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching NhaCungCap: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải nhà cung cấp. Vui lòng thử lại.')),
      );
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    if (itemNCC != null) {
      try {
        NhaCungCap updatedNCC = NhaCungCap(
          maNCC: itemNCC!.maNCC,
          tenNCC: tenNCCController.text,
          sdt: sdtController.text,
          email: emailController.text,
          diaChi: diaChiController.text,
        );

        await nccController.updateNhaCungCap(updatedNCC.maNCC, updatedNCC);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật nhà cung cấp thành công')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        print('Error saving changes: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi cập nhật. Vui lòng kiểm tra lại')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
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
                        'SỬA NHÀ CUNG CẤP',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  children: [
                    TextField(
                      controller: tenNCCController,
                      decoration: const InputDecoration(
                        labelText: 'Tên nhà cung cấp',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: sdtController,
                      decoration: const InputDecoration(
                        labelText: 'Số điện thoại',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: diaChiController,
                      decoration: const InputDecoration(
                        labelText: 'Địa chỉ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Save button
                    ElevatedButton(
                      onPressed: () {
                        saveChanges(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                        'Lưu',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}