import 'package:flutter/material.dart';

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