import 'package:datn_cntt304_bandogiadung/controllers/NhanVienController.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/SanPham/Admin_SanPham.dart';
import 'package:datn_cntt304_bandogiadung/views/BaoCao/BaoCaoScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/BaoCao/StoreReport.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/DoiTra/ReturnListScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/DonHang/QuanLyDonHang.dart';
import 'package:flutter/material.dart';

import '../../controllers/DonHangController.dart';
import '../../models/DonHang.dart';
import 'ThongKeKho.dart';

class ShopDashboard extends StatefulWidget {
  final String maNV;

  ShopDashboard({Key? key, required this.maNV}) : super(key: key);

  @override
  _ShopDashboardState createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  final DonHangController _donHangController = DonHangController();
  int processingOrdersCount = 0;
  int todayOrdersCount = 0;
  int doneOrdersCount = 0;
  double totalRevenue = 0.0;
  double profit = 0.0;
  String? chucVu;
  @override
  void initState() {
    super.initState();
    _loadChucVu();
    if(chucVu=='QUAN_LY')
      {
        _fetchTodayStatistics();
      }


  }
  Future<void> _loadChucVu() async {
    NhanVienController nhanVienController=NhanVienController();
    chucVu = await nhanVienController.getChucVu();
    setState(() {}); // Update the UI with the new chucVu value
  }
  Future<void> _fetchTodayStatistics() async {
    // Calculate today's statistics
    Map<String, dynamic> todayStats = await _donHangController
        .calculateTodayStatistics();

    // Update state with the fetched values
    setState(() {
      processingOrdersCount = todayStats['processingOrders'] ?? 0;
      todayOrdersCount = todayStats['todayOrders'] ?? 0;
      doneOrdersCount = todayStats['doneOrdersCount'] ?? 0;
      totalRevenue = todayStats['totalRevenue'] ?? 0.0;
      profit = todayStats['profit'] ?? 0.0;
    });
  }

  String formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false; // Return false để chặn không cho quay lại
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.store, color: Colors.green),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${chucVu}', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.chat_bubble_outline), onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.notifications_none), onPressed: () {}),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(chucVu!='THU_KHO'&&chucVu!='BAN_HANG')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hôm nay', style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),

                    ],
                  ),
                  SizedBox(height: 10),
                  if(chucVu!='THU_KHO'&&chucVu!='BAN_HANG')
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatCard('Doanh thu', formatCurrency(totalRevenue),
                          Icons.bar_chart, Colors.orange),
                      _buildStatCard('Đơn mới', todayOrdersCount.toString(),
                          Icons.new_releases, Colors.blue),
                      _buildStatCard('Lợi nhuận', formatCurrency(profit),
                          Icons.attach_money, Colors.green),
                      _buildStatCard('Đơn đã giao', doneOrdersCount.toString(),
                          Icons.check_circle_outline, Colors.yellow),
                    ],
                  ),
                  SizedBox(height: 20),
                  if(chucVu!='THU_KHO')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Đơn hàng', style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  if(chucVu!='THU_KHO')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildOrderStatusItem(
                        'Chờ xác nhận',
                        processingOrdersCount.toString(),
                        Colors.red,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                  context) => (TodaysOrdersScreen()), // Replace with your actual screen
                            ),
                          );
                        },
                      ),
                      _buildOrderStatusItem(
                          'Tổng đơn hàng', todayOrdersCount.toString(),
                          Colors.blue),
                    ],
                  ),
                  SizedBox(height: 20),

                  GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      if(chucVu!='THU_KHO')
                      _buildActionButton('Đơn hàng', Icons.list_alt,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (
                                    context) => (TodaysOrdersScreen()), // Replace with your actual screen
                              ),
                            );
                          }),
                      if(chucVu!='THU_KHO'&&chucVu!='BAN_HANG')
                      _buildActionButton(
                          'Sản phẩm', Icons.inventory, onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => AdminSanPhamScreen()));
                      }),
                      if(chucVu!='BAN_HANG')
                      _buildActionButton(
                        'Kho hàng',
                        Icons.store,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WarehouseInfoScreen(maNV: widget.maNV),
                            ),
                          );
                        },
                      ),
                      if(chucVu!='THU_KHO'&&chucVu!='BAN_HANG')
                      _buildActionButton(
                        'Đổi trả',
                        Icons.swap_horiz,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReturnListScreen(), // Thay thế bằng màn hình đổi trả của bạn
                            ),
                          );
                        },
                      ),
                      if(chucVu!='THU_KHO'&&chucVu!='BAN_HANG')
                      _buildActionButton(
                        'Báo cáo',
                        Icons.insert_chart,
                        onPressed: () {
                          // Add your navigation or functionality here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreReport(),
                            ),
                          );
                        },
                      ),
                      _buildActionButton('Nhân viên', Icons.people_outline),
                      _buildActionButton(
                        'Đăng xuất ', Icons.logout, onPressed: () {
                        // Add your navigation or functionality here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen(), // Change to your report screen
                          ),
                        );
                      },),
                    ],
                  ),

                ],
              ),
            ),
          ),
        )
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
            Text(value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusItem(String title, String count, Color color,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                count,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildActionButton(String title, IconData icon,
      {String? badge, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Thêm dòng này
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[100],
                radius: 20, // Giảm kích thước của CircleAvatar
                child: Icon(icon, color: Colors.green,
                    size: 20), // Giảm kích thước của Icon
              ),
              if (badge != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      badge,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2), // Giảm khoảng cách
          Text(
            title,
            style: TextStyle(fontSize: 11), // Giảm kích thước chữ
            textAlign: TextAlign.center,
            maxLines: 1, // Giới hạn số dòng
            overflow: TextOverflow.ellipsis, // Xử lý text bị tràn
          ),
        ],
      ),
    );
  }
}
