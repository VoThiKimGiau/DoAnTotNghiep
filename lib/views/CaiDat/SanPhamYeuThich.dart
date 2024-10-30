import 'package:datn_cntt304_bandogiadung/controllers/SPYeuThichController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/SPYeuThich.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/girdView_SanPham.dart';

class SanPhamYeuThichScreen extends StatefulWidget {
  String? maKH;

  SanPhamYeuThichScreen({required this.maKH});

  @override
  _SanPhamYeuThichScreen createState() => _SanPhamYeuThichScreen();
}

class _SanPhamYeuThichScreen extends State<SanPhamYeuThichScreen> {
  SPYeuThichController spYeuThichController = SPYeuThichController();
  SanPhamController sanPhamController = SanPhamController();
  List<SanPham>? lstSP;
  List<SPYeuThich>? lstSPYT;
  bool isLoading = true; // Add loading state variable

  @override
  void initState() {
    super.initState();
    fetchSPYT();
  }

  Future<void> fetchSPYT() async {
    try {
      List<SPYeuThich> fetchedItems =
      await spYeuThichController.fetchSPYeuThichByKH(widget.maKH);
      setState(() {
        lstSPYT = fetchedItems;
      });

      await fetchSP();
    } catch (e) {
      print('Error: $e');
      setState(() {
        lstSPYT = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSP() async {
    try {
      List<SanPham> items = [];
      for (SPYeuThich sp in lstSPYT!) {
        SanPham fetchedItem =
        await sanPhamController.getProductByMaSP(sp.maSanPham);
        items.add(fetchedItem);
      }
      setState(() {
        lstSP = items;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        lstSP = [];
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
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(left: 24, top: 74),
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
                Container(
                  margin: const EdgeInsets.only(top: 74, left: 43),
                  child: Text(
                    'Sản phẩm yêu thích (${lstSPYT?.length ?? 0})',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 42,
            ),
            Expanded(
              child: isLoading // Check loading state
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: GridViewSanPham(
                  itemsSP: lstSP ?? [],
                  maKH: widget.maKH,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}