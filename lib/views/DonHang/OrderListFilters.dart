import 'package:flutter/material.dart';

class OrderListFilters extends StatelessWidget {
  final Function(String?) onStatusChanged;
  final Function(DateTime?) onDateChanged;
  final String? selectedStatus;
  final DateTime? selectedDate;

  const OrderListFilters({
    Key? key,
    required this.onStatusChanged,
    required this.onDateChanged,
    this.selectedStatus,
    this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: selectedStatus,
              hint: Text('Trạng thái'),
              onChanged: onStatusChanged,
              items: [
                DropdownMenuItem(value: null, child: Text('Tất cả')),
                DropdownMenuItem(value: 'Đang xử lý', child: Text('Đang xử lý ')),
                DropdownMenuItem(value: 'Đang giao hàng', child: Text('Đang giao hàng')),
                DropdownMenuItem(value: 'Đã giao hàng', child: Text('Đã giao hàng')),
                DropdownMenuItem(value: 'Đã hủy', child: Text('Đã hủy')),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  onDateChanged(picked);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Ngày đặt hàng',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : 'Chọn ngày',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}