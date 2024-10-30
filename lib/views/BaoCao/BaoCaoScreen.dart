import 'package:datn_cntt304_bandogiadung/views/BaoCao/StoreReport.dart';
import 'package:flutter/material.dart';

class BaoCaoScreen extends StatefulWidget {
  @override
  _BaoCaoScreenState createState() => _BaoCaoScreenState();
}

class _BaoCaoScreenState extends State<BaoCaoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo cáo'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildGridItem('Lãi lỗ', Icons.bar_chart),
          _buildGridItem('Cửa hàng', Icons.store),
          _buildGridItem('Bán hàng', Icons.shopping_cart),
          _buildGridItem('Kho hàng', Icons.warehouse),
          _buildGridItem('Biến động tồn', Icons.swap_vert),
          _buildGridItem('Thu chi', Icons.attach_money),
          _buildGridItem('Công nợ', Icons.assignment_ind),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon) {
    return InkWell(
      onTap: () {
        if (title == 'Cửa hàng') {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>StoreReport()));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}