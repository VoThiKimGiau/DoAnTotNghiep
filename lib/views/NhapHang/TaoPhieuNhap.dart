import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhaCungCapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:flutter/material.dart';
import '../../models/ChiTietSP.dart';

class InventoryEntryScreen extends StatefulWidget {
  final String newOrderCode;
  InventoryEntryScreen({Key? key, required this.newOrderCode}) : super(key: key);

  @override
  _InventoryEntryScreenState createState() => _InventoryEntryScreenState();
}

class _InventoryEntryScreenState extends State<InventoryEntryScreen> {
  String? selectedSupplier;  // Nullable to allow no initial value
  List<NhaCungCap> suppliers = [];  // Supplier list from API
  List<ChiTietSP> chiTietSPs = []; // Product details list
  NCCController nccController = NCCController();
  ChiTietSPController chiTietSPController = ChiTietSPController();
  List<int> quantities = [0, 0, 0]; // Quantities for products
  SanPhamController sanPhamController = SanPhamController();
  bool isLoading = true;

  late MauSPController mauSPController = MauSPController();
  late KichCoController kichCoController = KichCoController();

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
  }

  Future<String> layTenMau(String maMau) async {
    try {
      return await mauSPController.layTenMauByMaMau(maMau);
    } catch (error) {
      return 'Lỗi hiển thị màu';
    }
  }

  Future<String> layTenKichCo(String maKichCo) async {
    try {
      return await kichCoController.layTenKichCo(maKichCo);
    } catch (error) {
      return 'Lỗi hiển thị kích cỡ';
    }
  }

  Future<String?> layTenSP(String masp) async {
    String? ten = await sanPhamController.getProductNameByMaSP(masp);
    if (ten != "") {
      return ten;
    } else {
      throw Exception("Lấy tên sản phẩm thất bại!");
    }
  }

  // Fetch danh sách nhà cung cấp
  Future<void> _fetchSuppliers() async {
    try {
      List<NhaCungCap> fetchedSuppliers = await nccController.fetchSuppliers();
      setState(() {
        suppliers = fetchedSuppliers;
        if (suppliers.isNotEmpty) {
          selectedSupplier = suppliers[0].maNCC; // Default to the first supplier
          _fetchChiTietSPBySupplier(suppliers[0].maNCC); // Fetch products for the first supplier
        } else {
          selectedSupplier = null; // Set to null if no suppliers
        }
      });
    } catch (e) {
      print('Error fetching suppliers: $e');
    }
  }

  // Fetch danh sách chi tiết sản phẩm theo nhà cung cấp
  Future<void> _fetchChiTietSPBySupplier(String maNCC) async {
    try {
      List<ChiTietSP> fetchedChiTietSPs = await chiTietSPController.fetchAllChiTietSPByMaNCC(maNCC);
      setState(() {
        chiTietSPs = fetchedChiTietSPs;
        quantities = List<int>.filled(chiTietSPs.length, 0); // Initialize quantities for products
      });
    } catch (e) {
      print('Error fetching ChiTietSP: $e');
    }
  }

  // Fetch product details and return as a Map
  Future<Map<String, String?>> fetchProductDetails(ChiTietSP ctsp) async {
    Map<String, String?> productDetails = {};
    try {
      productDetails['productName'] = await layTenSP(ctsp.maSP);
      productDetails['size'] = await layTenKichCo(ctsp.maKichCo);
      productDetails['color'] = await layTenMau(ctsp.maMau);
    } catch (e) {
      print('Error fetching product details: $e');
    }
    return productDetails; // Return the details
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
            Text('PN10', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Nhà cung cấp'),
            suppliers.isEmpty
                ? CircularProgressIndicator() // Show loading when no data
                : DropdownButton<String>(
              value: selectedSupplier,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSupplier = newValue;
                  // Fetch products when changing supplier
                  if (newValue != null) {
                    _fetchChiTietSPBySupplier(newValue);
                  }
                });
              },
              items: suppliers.map<DropdownMenuItem<String>>((NhaCungCap supplier) {
                return DropdownMenuItem<String>(
                  value: supplier.maNCC,
                  child: Text(utf8.decode(supplier.tenNCC.runes.toList())),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // Expanded widget to allow scrolling of product entries
            Expanded(
              child: chiTietSPs.isEmpty
                  ? Center(child: Text('Không có sản phẩm nào'))
                  : ListView.builder(
                itemCount: chiTietSPs.length,
                itemBuilder: (context, index) {
                  return _buildProductEntry(index, chiTietSPs[index]);
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tạm tính:', style: TextStyle(fontSize: 18)),
                Text('999999đ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle confirm order
                },
                child: Text('Xác nhận (${quantities.reduce((a, b) => a + b)})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildProductEntry(int index, ChiTietSP chiTietSP) {
    return FutureBuilder<Map<String, String?>>(
      future: fetchProductDetails(chiTietSP), // Fetch product details asynchronously
      builder: (BuildContext context, AsyncSnapshot<Map<String, String?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading while fetching
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error if any
        } else {
          final productDetails = snapshot.data;
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${productDetails != null ? utf8.decode(productDetails['productName']?.runes.toList() ?? []) : 'Unknown Product'}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // Apply utf8.decode to size and color if needed
                Text('${productDetails != null ? utf8.decode(productDetails['size']?.runes.toList() ?? []) : 'Unknown Size'} -  ${productDetails != null ? utf8.decode(productDetails['color']?.runes.toList() ?? []) : 'Unknown Color'}'),

                Text('${chiTietSP.giaBan}'),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (quantities[index] > 0) quantities[index]--;
                        });
                      },
                    ),
                    Text('${quantities[index]}'),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          quantities[index]++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
