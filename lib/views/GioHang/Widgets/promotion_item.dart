import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KMKHController.dart';
import 'package:datn_cntt304_bandogiadung/models/Promotion.dart';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:flutter/material.dart';

class PromotionItem extends StatefulWidget {
  PromotionItem({
    super.key,
    required this.promotion,
    required this.isSelect,
    required this.maKH,
  });

  final Promotion promotion;
  bool isSelect;
  String? maKH;

  @override
  State<PromotionItem> createState() => _PromotionItemState();
}

class _PromotionItemState extends State<PromotionItem> {
  SharedFunction sharedFunction = SharedFunction();
  KMKHController kmkhController  = KMKHController();
  int? slCon;

  @override
  void initState() {
    super.initState();
    _loadSLCon();
  }

  Future<void> _loadSLCon() async {
    try {
      int? quantity = await kmkhController.getSoLuong(widget.maKH!, widget.promotion.maKm);
      setState(() {
        slCon = quantity;
      });
    } catch (e) {
      setState(() {
        slCon = -1;
      });
    }
  }

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
                "Giảm ${sharedFunction.formatCurrency(widget.promotion.triGiaGiam)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Đơn tối thiểu ${sharedFunction.formatCurrency(widget.promotion.triGiaToiThieu)}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              Text(
                'HSD: ${widget.promotion.ngayKetThuc.day}/${widget.promotion.ngayKetThuc.month}/${widget.promotion.ngayKetThuc.year}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                'x${slCon ?? -1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gabarito',
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5,),
              Icon(
                widget.isSelect ? Icons.check_circle : Icons.check_circle_outline,
                color: AppColors.primaryColor,
              )
            ],
          ),
        ],
      ),
    );
  }
}