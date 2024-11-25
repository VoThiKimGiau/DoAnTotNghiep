import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/TTNhanHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/TTNhanHang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/GiaoHangController.dart';

class ChiTietTTNHScreen extends StatefulWidget {
  final String maTTNH;

  ChiTietTTNHScreen({required this.maTTNH});

  @override
  _ChiTietTTNHScreen createState() => _ChiTietTTNHScreen();
}

class _ChiTietTTNHScreen extends State<ChiTietTTNHScreen> {
  late TTNhanHangController ttNhanHangController;
  TTNhanHang? ttNhanHang;

  TextEditingController? hoTenController;
  TextEditingController? sdtController;
  TextEditingController? diaChiController;
  bool macDinh = false;

  @override
  void initState() {
    super.initState();
    ttNhanHangController = TTNhanHangController();
    fetchTTNH();
  }

  Future<void> fetchTTNH() async {
    try {
      TTNhanHang? fetchedItem =
          await ttNhanHangController.fetchTTNhanHang(widget.maTTNH);
      setState(() {
        ttNhanHang = fetchedItem;
        if (fetchedItem != null) {
          hoTenController = TextEditingController(text: fetchedItem.hoTen);
          sdtController = TextEditingController(text: fetchedItem.sdt);
          diaChiController = TextEditingController(text: fetchedItem.diaChi);
          macDinh = fetchedItem.macDinh;
        }
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        ttNhanHang = null;
      });
    }
  }

  @override
  void dispose() {
    hoTenController?.dispose();
    sdtController?.dispose();
    diaChiController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      'SỬA THÔNG TIN NHẬN HÀNG',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ttNhanHang != null) ...[
                      TextField(
                        controller: hoTenController,
                        decoration: const InputDecoration(
                          labelText: 'Họ Tên',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: sdtController,
                        decoration: const InputDecoration(
                          labelText: 'Số Điện Thoại',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: diaChiController,
                        decoration: const InputDecoration(
                          labelText: 'Địa Chỉ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Đặt làm địa chỉ mặc định',
                            style: TextStyle(fontSize: 16),
                          ),
                          Switch(
                            activeColor: Colors.deepOrange,
                            value: macDinh,
                            onChanged: (value) {
                              setState(() {
                                macDinh = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await ttNhanHangController
                          .deleteTTNhanHang(widget.maTTNH);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Xóa thông tin thành công'),
                          ),
                        );
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Không xóa được. Vui lòng thử lại'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text(
                      'Xóa địa chỉ',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      GiaoHangController giaoHangController =
                          GiaoHangController();
                      const String APIKEY =
                          '8AOpT7e0QxfGS0TLD08A4M66K80ioaXiwMU1zUUv9IY';

                      String diaChi = diaChiController?.text.trim() ?? '';
                      String toaDoDC = '';

                      try {
                        final coords1 = await giaoHangController.getCoordinates(
                            diaChi, APIKEY);
                        toaDoDC =
                            '${coords1['latitude']},${coords1['longitude']}';

                        TTNhanHang updatedAddress = TTNhanHang(
                          maTTNH: widget.maTTNH,
                          hoTen: hoTenController?.text ?? '',
                          diaChi: diaChi,
                          sdt: sdtController?.text ?? '',
                          maKH: ttNhanHang!.maKH,
                          macDinh: macDinh,
                          toaDo: toaDoDC,
                        );

                        bool success = await ttNhanHangController
                            .updateTTNhanHang(widget.maTTNH, updatedAddress);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật thông tin thành công'),
                            ),
                          );
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Cập nhật thông tin thất bại. Vui lòng thử lại'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Địa chỉ không hợp lệ. Vui lòng kiểm tra lại'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text(
                      'HOÀN THÀNH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
