import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/SanPhamController.dart';
import '../../models/SanPham.dart';
import '../../widgets/girdView_SanPham.dart';

class SearchResultScreen extends StatefulWidget {
  String? maKH;
  late String query;

  SearchResultScreen({required this.maKH, required this.query});

  @override
  _SearchResultScreen createState() => _SearchResultScreen();
}

class _SearchResultScreen extends State<SearchResultScreen> {
  SanPhamController sanPhamController = SanPhamController();
  List<SanPham>? itemsSP;

  final TextEditingController _searchController = TextEditingController();
  List<SanPham>? _filteredData = [];

  @override
  void initState() {
    super.initState();
    fetchSP();
  }

  Future<void> fetchSP() async {
    try {
      // Gọi phương thức từ controller
      List<SanPham> fetchedItems = await sanPhamController.fetchSanPham();
      setState(() {
        itemsSP = fetchedItems; // Cập nhật danh sách
      });
    } catch (e) {
      print('Error: $e'); // Xử lý lỗi
      setState(() {
        itemsSP = []; // Đặt danh sách thành rỗng nếu có lỗi
      });
    }
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredData = [];
      });
    } else {
      setState(() {
        _filteredData = itemsSP!
            .where((item) =>
                item.tenSP.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
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
                height: 50,
                margin: const EdgeInsets.only(top: 63),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(left: 24),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                        ),
                        child: SvgPicture.asset('assets/icons/arrowleft.svg'),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 36),
                      child: ElevatedButton(
                        onPressed: () {
                          print('b');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                        ),
                        child: Image.asset(
                          'assets/icons/account_icon.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Use a Container with a fixed height instead of Expanded
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: MediaQuery.of(context).size.height * 0.65, // Set a specific height
                child: GridViewSanPham(
                  itemsSP: itemsSP ?? [],
                  maKH: widget.maKH,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}