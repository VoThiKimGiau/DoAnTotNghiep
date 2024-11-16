import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/TTNhanHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/TTNhanHang.dart';
import 'package:datn_cntt304_bandogiadung/views/CaiDat/ThemDiaChi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TTNhanHangScreen extends StatefulWidget {
  final String? maKH;

  TTNhanHangScreen({required this.maKH});

  _TTNhanHangScreen createState() => _TTNhanHangScreen();
}

class _TTNhanHangScreen extends State<TTNhanHangScreen> {
  final TTNhanHangController ttNhanHangController = TTNhanHangController();
  List<TTNhanHang>? dsTTNH;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTTNH();
  }

  Future<void> fetchTTNH() async {
    try {
      List<TTNhanHang> fetchedItems =
      await ttNhanHangController.fetchTTNhanHangByCustomer(widget.maKH);
      setState(() {
        dsTTNH = fetchedItems;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        dsTTNH = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Text(
                      'THÔNG TIN NHẬN HÀNG',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : dsTTNH == null || dsTTNH!.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/address.png'),
                    const SizedBox(height: 20),
                    const Text(
                      'Bạn chưa có thông tin nhận hàng nào',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
                  : Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ListView.builder(
                  itemCount: dsTTNH?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = dsTTNH![index];
                    return GestureDetector(
                      onTap: () {
                        print('Sửa');
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.hoTen,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Gabarito',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: const Text('|'),
                                  ),
                                  Text(
                                    item.sdt,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontFamily: 'Gabarito',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 50),
                              Text(
                                item.diaChi,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'Gabarito',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.macDinh) // Check if macDinh is true
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.red),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Mặc định',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddDeliveryAddressScreen(maKH: widget.maKH),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text(
                  'Thêm thông tin',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}