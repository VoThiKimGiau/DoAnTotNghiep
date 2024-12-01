import 'package:flutter/material.dart';
import '../../../models/DanhMucSP.dart';

class AdminItemCategory extends StatelessWidget {
  final DanhMucSP category;
  final VoidCallback onPressed;

  AdminItemCategory({required this.category, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: Image.network(
                    category.anhDanhMuc,
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              category.tenDanhMuc,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}