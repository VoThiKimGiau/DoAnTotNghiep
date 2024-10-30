import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhaCungCapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/PhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import './ProductSelectionScreen.dart';

class InventoryEntryScreen extends StatefulWidget {
  final String newOrderCode;
  final String maNV;

  InventoryEntryScreen({
    Key? key,
    required this.newOrderCode,
    required this.maNV,
  }) : super(key: key);

  @override
  _InventoryEntryScreenState createState() => _InventoryEntryScreenState();
}

class _InventoryEntryScreenState extends State<InventoryEntryScreen> {
  String? selectedSupplier;
  List<NhaCungCap> suppliers = [];
  NCCController nccController = NCCController();
  PhieuNhapController phieuNhapController = PhieuNhapController();
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
  }

  Future<void> _fetchSuppliers() async {
    try {
      List<NhaCungCap> fetchedSuppliers = await nccController.fetchSuppliers();
      setState(() {
        suppliers = fetchedSuppliers;
        if (suppliers.isNotEmpty) {
          selectedSupplier = suppliers[0].maNCC;
        }
      });
    } catch (e) {
      print('Error fetching suppliers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải danh sách nhà cung cấp')),
      );
    }
  }

  Future<void> _createAndNavigate() async {
    if (selectedSupplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn nhà cung cấp')),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      PhieuNhap phieuNhap = PhieuNhap(
        maPhieuNhap: widget.newOrderCode,
        nhaCungCap: selectedSupplier!,
        maNV: widget.maNV,
        tongTien: 0,
        ngayDat: DateTime.now(),
        trangThai: 'Đang xử lý',
      );

      PhieuNhap createdPhieuNhap = await phieuNhapController.taoPhieuNhap(phieuNhap);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductSelectionScreen(
            maPhieuNhap: widget.newOrderCode,
            maNCC: selectedSupplier!,
            maNV: widget.maNV,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tạo phiếu nhập: $e')),
      );
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập hàng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Mã phiếu nhập: ${widget.newOrderCode}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            // Supplier Selection Section
            Text(
              'Chọn nhà cung cấp',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            suppliers.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSupplier,
                  isExpanded: true,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSupplier = newValue;
                    });
                  },
                  items: suppliers.map<DropdownMenuItem<String>>((NhaCungCap supplier) {
                    return DropdownMenuItem<String>(
                      value: supplier.maNCC,
                      child: Text(
                        utf8.decode(supplier.tenNCC.runes.toList()),
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Spacer to push button to bottom
            Spacer(),

            // Create Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isCreating ? null : _createAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: _isCreating
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  'Tạo phiếu nhập',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}