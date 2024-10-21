import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SharedFunction{

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    String formattedAmount = formatter.format(amount);
    return '$formattedAmountđ';
  }

}