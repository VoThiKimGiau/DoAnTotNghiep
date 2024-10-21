import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/payment_screen.dart'; // Import PaymentScreen

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Biến trạng thái cho số lượng sản phẩm
  List<int> quantities = [1, 1]; // Mảng lưu trữ số lượng mỗi sản phẩm

  // Biến trạng thái cho tổng tiền
  double total = 208; // Tổng tiền sản phẩm + phí giao hàng

  // Hàm cập nhật số lượng sản phẩm
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      quantities[index] = newQuantity;
      total = _calculateTotal(); // Cập nhật tổng tiền
    });
  }

  // Hàm xóa tất cả sản phẩm trong giỏ hàng
  void _clearCart() {
    setState(() {
      quantities = [1, 1].map((_) => 0).toList(); // Đặt số lượng về 0
      total = 8; // Đặt tổng tiền về phí giao hàng
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Giỏ hàng'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearCart, // Gọi hàm xóa giỏ hàng
            tooltip: 'Xoá tất cả',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Danh sách sản phẩm trong giỏ hàng
            Expanded(
              child: ListView.builder(
                itemCount: 2, // Thay đổi số lượng sản phẩm
                itemBuilder: (context, index) {
                  return CartItem(
                    productName: 'Sản phẩm ${index + 1}',
                    price: index == 0 ? 148 : 52, // Thay đổi giá
                    quantity: quantities[index], // Hiển thị số lượng
                    onQuantityChanged: (newQuantity) =>
                        _updateQuantity(index, newQuantity), // Gọi hàm cập nhật số lượng
                  );
                },
              ),
            ),

            // Tổng kết đơn hàng
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tóm tính',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                _buildSummaryItem('Phí giao hàng', '\$8.00'),
                SizedBox(height: 8.0),
                _buildSummaryItem(
                    'Tổng cộng',
                    '\$${total.toStringAsFixed(2)}'), // Hiển thị tổng cộng
              ],
            ),

            // Nút Tiếp tục
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Chuyển đến trang thanh toán
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      total: total, // Truyền tổng tiền
                    ), // Chuyển đến PaymentScreen
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Tiếp tục'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  // Hàm tạo widget hiển thị một mục tổng kết
  Widget _buildSummaryItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Hàm tính tổng tiền
  double _calculateTotal() {
    double total = 0;
    for (int i = 0; i < quantities.length; i++) {
      total += quantities[i] * (i == 0 ? 148 : 52);
    }
    return total;
  }
}

// Widget hiển thị một sản phẩm trong giỏ hàng
class CartItem extends StatefulWidget {
  final String productName;
  final double price;
  final int quantity;
  final Function(int) onQuantityChanged;

  const CartItem({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.productName,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Row(
              children: [
                Text(
                  '\$${(widget.price * widget.quantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16.0),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    widget.onQuantityChanged(widget.quantity + 1); // Gọi hàm cập nhật số lượng
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (widget.quantity > 1) {
                      widget.onQuantityChanged(widget.quantity - 1); // Gọi hàm cập nhật số lượng
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}