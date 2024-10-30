import 'package:flutter/material.dart';
class ActionButton extends StatelessWidget {
  final String text;

  const ActionButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // Khoảng cách giữa các nút
      child: Container(
        width: double.infinity,
        height: 48, // Chiều cao cố định cho nút
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300), // Viền cho nút
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Padding nội dung bên trong nút
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}