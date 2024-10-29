import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/SanPhamController.dart';
import '../../models/SanPham.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/girdView_SanPham.dart';
import '../CaiDat/ProfileScreen.dart';
import '../DonHang/DonHang.dart';
import '../ThongBao/DanhSachTB.dart';
import 'TrangChu.dart';

class SearchScreen extends StatefulWidget {
  final String? maKH;

  SearchScreen({required this.maKH});

  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  final SanPhamController sanPhamController = SanPhamController();
  List<SanPham>? itemsSP;
  final TextEditingController _searchController = TextEditingController();
  List<SanPham>? _filteredData = [];

  int _selectedIndex = -3; // Default to -3
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSP(); // Fetch data after the build context is available
    });

    _widgetOptions = [
      TrangChuScreen(maKhachHang: widget.maKH),
      NotificationScreen(maKhachHang: widget.maKH),
      OrderListScreen(maKH: widget.maKH),
      ProfileScreen(makh: widget.maKH),
      // Placeholder for the search and grid view
      Container(), // Add a placeholder for the search screen in the list
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      // Adjust index for the Bottom Navigation
      _selectedIndex = index == 4 ? -3 : index; // Map to -3 for search screen
    });
  }

  Future<void> fetchSP() async {
    try {
      List<SanPham> fetchedItems = await sanPhamController.fetchSanPham();
      setState(() {
        itemsSP = fetchedItems;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        itemsSP = [];
      });
    }
  }

  Widget _buildSearchAndGridView() {
    return Column(
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
                    print('Account button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  child: Image.asset('assets/icons/account_icon.png'),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          height: MediaQuery.of(context).size.height * 0.65,
          child: GridViewSanPham(
            itemsSP: itemsSP ?? [],
            maKH: widget.maKH,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _selectedIndex == -3 ? _buildSearchAndGridView() : _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex == -3 ? 4 : _selectedIndex, // Ensure valid index
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}