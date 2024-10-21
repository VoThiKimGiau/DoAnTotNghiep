import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/widgets/item_SanPham.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/DanhMucSPController.dart';

class TrangChuScreen extends StatefulWidget {
  @override
  State<TrangChuScreen> createState() => _TrangChuScreen();
}

class _TrangChuScreen extends State<TrangChuScreen> {
  DanhMucSPController DMSPController = DanhMucSPController();
  List<DanhMucSP>? items;

  SanPhamController SPController = SanPhamController();
  List<SanPham>? items_SP;

  @override
  void initState() {
    super.initState();
    fetchDanhMucSP();
    fetchSP();
  }

  Future<void> fetchDanhMucSP() async {
    try {
      // Gọi phương thức từ controller
      List<DanhMucSP> fetchedItems = await DMSPController.fetchDanhMucSP();
      setState(() {
        items = fetchedItems; // Cập nhật danh sách
      });
    } catch (e) {
      print('Error: $e'); // Xử lý lỗi
      setState(() {
        items = []; // Đặt danh sách thành rỗng nếu có lỗi
      });
    }
  }

  Future<void> fetchSP() async {
    try {
      // Gọi phương thức từ controller
      List<SanPham> fetchedItems = await SPController.fetchSanPham();
      setState(() {
        items_SP = fetchedItems; // Cập nhật danh sách
      });
    } catch (e) {
      print('Error: $e'); // Xử lý lỗi
      setState(() {
        items_SP = []; // Đặt danh sách thành rỗng nếu có lỗi
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredData = [];
  List<String> _data = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Grape',
    'Kiwi',
    'Mango',
    'Orange',
  ];

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredData = [];
      });
    } else {
      setState(() {
        _filteredData = _data
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ElevatedButton(
                onPressed: () {
                  print('a');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Image.asset('assets/icons/account_icon.png'),
              ),
            ),
            const Text('CỬA HÀNG GIA DỤNG HUIT',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 15)),
            SizedBox(
              width: 40,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  print('b');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: AppColors.primaryColor,
                ),
                child: SvgPicture.asset('assets/icons/bag2.svg'),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: SearchBar(
            controller: _searchController,
            onChanged: _filterData,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Danh mục',
                  style: TextStyle(
                      fontFamily: 'Gabarito',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor)),
              TextButton(
                  onPressed: () {
                    print('a');
                  },
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ))
            ],
          ),
        ),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items!.length >= 5 ? 5 : items!.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: 30,
                        child: ClipOval(
                          child: Image.network(
                            items![index].anhDanhMuc,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      items![index].tenDanhMuc, // Tên của mục
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 36, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Bán chạy',
                  style: TextStyle(
                    fontFamily: 'Gabarito',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor)),
              TextButton(
                  onPressed: () {
                    print('a');
                  },
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ))
            ],
          ),
        ),
        Container(
            height: 280,
            width: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items_SP!.length > 5 ? 5 : items_SP!.length,
              itemBuilder: (context, index) {
                return SanPhamItem(item: items_SP![index]); // Gọi widget item
              },
            )),
        Container(
          margin: const EdgeInsets.only(top: 36, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Mới',
                  style: TextStyle(
                      fontFamily: 'Gabarito',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor)),
              TextButton(
                  onPressed: () {
                    print('a');
                  },
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ))
            ],
          ),
        ),
        Container(
            height: 280,
            width: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items_SP!.length > 5 ? 5 : items_SP!.length,
              itemBuilder: (context, index) {
                return SanPhamItem(item: items_SP![index]); // Gọi widget item
              },
            )),
      ],
    )));
  }
}
