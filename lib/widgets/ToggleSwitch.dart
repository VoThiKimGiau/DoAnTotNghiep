import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleSwitch({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Đảm bảo Row chỉ chiếm không gian cần thiết
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis, // Xử lý text dài
            ),
          ),
          SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}