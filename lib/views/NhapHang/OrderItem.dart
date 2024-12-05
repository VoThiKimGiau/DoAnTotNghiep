
import 'dart:convert';

import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String orderNumber;
  final int itemCount;
  final double totalAmount;
  final String status;

  const OrderItem({
    Key? key,
    required this.orderNumber,
    required this.itemCount,
    required this.status,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.grey,size: 22),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mã phiếu: $orderNumber',
                  style: TextStyle(fontSize: 20,fontFamily: 'Comfortaa'),
                ),
                Text('Trạng thái: ${utf8.decode(status.runes.toList())}', style: TextStyle(fontSize:18,color: Colors.grey,fontFamily: 'Comfortaa')),

                Text('Số lượng chi tiết: $itemCount', style: TextStyle(fontSize:18,color: Colors.grey,fontFamily: 'Comfortaa')),
                Text('Tổng tiền: ${totalAmount.toStringAsFixed(0)} VNĐ', style: TextStyle(fontSize:18,color: Colors.grey,fontFamily: 'Comfortaa')),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
