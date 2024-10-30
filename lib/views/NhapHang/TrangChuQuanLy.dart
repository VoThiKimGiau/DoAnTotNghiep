import 'package:datn_cntt304_bandogiadung/views/BaoCao/BaoCaoScreen.dart';
import 'package:datn_cntt304_bandogiadung/views/DangNhap/LoginScreen.dart';
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
  int doneOrdersCount=0;
  double totalRevenue=0.0;
  @override
  void initState() {
    super.initState();
    _fetchTodayStatistics();
  }
  Future<void> _fetchTodayStatistics() async {

    // Calculate today's statistics
    Map<String, dynamic> todayStats =await  _donHangController.calculateTodayStatistics();

    // Update state with the fetched values
    setState(() {
      processingOrdersCount = todayStats['processingOrders'] ?? 0;
      todayOrdersCount = todayStats['todayOrders'] ?? 0;
      doneOrdersCount=todayStats['doneOrdersCount']??0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
                Text('Gia dung', style: TextStyle(fontSize: 18)),
                Text('Mã shop: 822197', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hôm nay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Báo cáo chi tiết >', style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard('Doanh thu', '0', Icons.bar_chart, Colors.orange),
                  _buildStatCard('Đơn mới', processingOrdersCount.toString(), Icons.new_releases, Colors.blue),
                  _buildStatCard('Lợi nhuận', '0', Icons.attach_money, Colors.green),
                  _buildStatCard('Đơn đã giao', doneOrdersCount.toString(), Icons.check_circle_outline, Colors.yellow),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Đơn hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Tất cả >', style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOrderStatusItem('Chờ xác nhận', processingOrdersCount.toString(), Colors.red),
                  _buildOrderStatusItem('Tổng đơn hàng', todayOrdersCount.toString(), Colors.blue),
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
                  _buildActionButton('Tạo đơn', Icons.add_shopping_cart),
                  _buildActionButton('Đơn hàng', Icons.list_alt),
                  _buildActionButton('Sản phẩm', Icons.inventory),
                  _buildActionButton(
                    'Kho hàng',
                    Icons.store,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WarehouseInfoScreen(maNV: widget.maNV),
                        ),
                      );
                    },
                  ),
                  _buildActionButton('Khách hàng', Icons.people),
                  _buildActionButton('Thu chi', Icons.swap_vert),
                  _buildActionButton('Sổ nợ', Icons.account_balance_wallet),
                  _buildActionButton(
                    'Báo cáo',
                    Icons.insert_chart,
                    onPressed: () {
                      // Add your navigation or functionality here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BaoCaoScreen(), // Change to your report screen
                        ),
                      );
                    },
                  ),
                  _buildActionButton('Nhân viên', Icons.people_outline),
                  _buildActionButton('Đăng xuất ', Icons.logout,onPressed: () {
                    // Add your navigation or functionality here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(), // Change to your report screen
                      ),
                    );
                  },),
                ],
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Website của hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('https://0334492438.afada.vn', style: TextStyle(color: Colors.green)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.share),
                              label: Text('Chia sẻ'),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.settings),
                              label: Text('Cài đặt'),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusItem(String title, String count, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: color)),
        SizedBox(height: 5),
        Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, {String? badge, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Icon(icon, color: Colors.green),
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
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
