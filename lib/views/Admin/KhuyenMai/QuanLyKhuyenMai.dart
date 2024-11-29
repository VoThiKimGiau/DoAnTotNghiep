import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/views/Admin/KhuyenMai/GanMaKM.dart';
import 'package:datn_cntt304_bandogiadung/views/Admin/KhuyenMai/ThemKhuyenMai.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../controllers/KhuyenMaiController.dart';
import '../../../models/KhuyenMai.dart';

class PromotionManagementScreen extends StatefulWidget {
  const PromotionManagementScreen({Key? key}) : super(key: key);

  @override
  _PromotionManagementScreenState createState() => _PromotionManagementScreenState();
}

class _PromotionManagementScreenState extends State<PromotionManagementScreen> {
  final KhuyenMaiController _khuyenMaiController = KhuyenMaiController();
  List<KhuyenMai> promotions = [];
  List<KhuyenMai> filteredPromotions = [];
  bool isLoading = true;
  String selectedType = 'All';
  DateTime? selectedDate;
  TextEditingController searchController = TextEditingController();

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    primary: Colors.blue,
    secondary: Colors.orange,
    surface: Colors.white,
    background: Colors.grey[100]!,
    error: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    setState(() {
      isLoading = true;
    });
    try {
      final loadedPromotions = await _khuyenMaiController.getAllKhuyenMai();
      setState(() {
        promotions = loadedPromotions;
        filteredPromotions = loadedPromotions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Failed to load promotions: $e');
    }
  }

  void _filterPromotions() {
    setState(() {
      filteredPromotions = promotions.where((promotion) {
        bool typeMatch = selectedType == 'All' || utf8.decode(promotion.loaiKM.runes.toList()) == selectedType;
        bool dateMatch = selectedDate == null ||
            (promotion.ngayBatDau.isBefore(selectedDate!) &&
                promotion.ngayKetThuc.isAfter(selectedDate!));
        bool searchMatch = searchController.text.isEmpty ||
            promotion.moTa.toLowerCase().contains(searchController.text.toLowerCase());
        return typeMatch && dateMatch && searchMatch;
      }).toList();
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showPromotionDetails(KhuyenMai promotion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết khuyến mãi'), // Tiêu đề tiếng Việt
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Mã KM', promotion.maKM),
              _detailRow('Mô tả', utf8.decode(promotion.moTa.runes.toList())),
              _detailRow('Loại KM', utf8.decode(promotion.loaiKM.runes.toList())),
              _detailRow('Ngày bắt đầu', DateFormat('dd/MM/yyyy').format(promotion.ngayBatDau)),
              _detailRow('Ngày kết thúc', DateFormat('dd/MM/yyyy').format(promotion.ngayKetThuc)),
              _detailRow('Giá trị giảm', '${promotion.triGiaGiam}'),
              _detailRow('Giá trị tối thiểu', '${promotion.triGiaToiThieu}'),
              _detailRow('Số lần sử dụng', '${promotion.slkhNhan}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Đóng'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }


  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý khuyến mãi'),
        backgroundColor: colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Tìm theo tên',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => _filterPromotions(),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedType,
                  items: ['All', 'Phí vận chuyển', 'Giá trị đơn']
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                      _filterPromotions();
                    });
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                  _filterPromotions();
                });
              }
            },
            child: Text(selectedDate == null
                ? 'Select Date'
                : 'Date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadPromotions,
              child: ListView.builder(
                itemCount: filteredPromotions.length,
                itemBuilder: (context, index) {
                  final promotion = filteredPromotions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(

                      title: Text(promotion.maKM+'-'+ utf8.decode(promotion.moTa.runes.toList())),
                      subtitle: Text(
                        '${utf8.decode(promotion.loaiKM.runes.toList())} \n ${DateFormat('dd/MM/yyyy').format(promotion.ngayBatDau)} to ${DateFormat('dd/MM/yyyy').format(promotion.ngayKetThuc)}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () => _showPromotionDetails(promotion),
                        color: colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPromotionScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: colorScheme.secondary,
      ),
    );
  }
}

