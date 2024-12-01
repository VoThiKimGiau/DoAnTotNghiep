import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:datn_cntt304_bandogiadung/models/KichCo.dart';
import '../../../controllers/KichCoController.dart';

class AdminSuaKC extends StatefulWidget {
  final String maKichCo;

  AdminSuaKC({required this.maKichCo});

  @override
  _AdminSuaKCState createState() => _AdminSuaKCState();
}

class _AdminSuaKCState extends State<AdminSuaKC> {
  KichCoController kichCoController = KichCoController();
  KichCo? itemKC;
  bool isLoading = true;
  final TextEditingController tenKichCoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchKichCo();
  }

  Future<void> fetchKichCo() async {
    try {
      KichCo? fetchItem = await kichCoController.layKichCo(widget.maKichCo);
      if (fetchItem != null) {
        setState(() {
          itemKC = fetchItem;
          tenKichCoController.text = fetchItem.tenKichCo;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching KichCo: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải kích cỡ. Vui lòng thử lại.')),
      );
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    if (itemKC != null) {
      try {
        KichCo updatedKC = KichCo(
          maKichCo: itemKC!.maKichCo,
          tenKichCo: tenKichCoController.text,
        );

        await kichCoController.updateKichCo(updatedKC.maKichCo, updatedKC);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật kích cỡ thành công')),
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
                        'SỬA KÍCH CỠ',
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
                      controller: tenKichCoController,
                      decoration: const InputDecoration(
                        labelText: 'Tên kích cỡ',
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