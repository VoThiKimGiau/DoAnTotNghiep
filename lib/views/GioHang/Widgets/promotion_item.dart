import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/models/Promotion.dart';
import 'package:flutter/material.dart';

class PromotionItem extends StatefulWidget {
  const PromotionItem({
    super.key,
    required this.promotion,
    required this.isSelect,
  });

  final Promotion promotion;
  final bool isSelect;

  @override
  State<PromotionItem> createState() => _PromotionItemState();
}

class _PromotionItemState extends State<PromotionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 27,
        vertical: 6,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 19),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.promotion.moTa,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Đơn tối thiểu ${widget.promotion.triGiaToiThieu}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                'HSD: ${widget.promotion.ngayKetThuc.year}-${widget.promotion.ngayKetThuc.month}-${widget.promotion.ngayKetThuc.day}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          const Spacer(),
          Icon(
            widget.isSelect ? Icons.check_circle : Icons.check_circle_outline,
            color: AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}
