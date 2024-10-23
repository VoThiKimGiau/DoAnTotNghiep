import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhaCungCapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/PhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import '../../models/ChiTietSP.dart';
import 'XacNhanPhieuNhap.dart';

class InventoryEntryScreen extends StatefulWidget {
  final String newOrderCode;
  final String maNV;
  InventoryEntryScreen({Key? key, required this.newOrderCode,required this.maNV}) : super(key: key);

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
  PhieuNhapController phieuNhapController=PhieuNhapController();
  bool _isCreating = false;
  bool _isOrderCreated = false;
  late MauSPController mauSPController = MauSPController();
  late KichCoController kichCoController = KichCoController();
  Map<String, bool> selectedItems = {};
  final StorageService storageService = StorageService();
  double temporaryTotal = 0.0;
  Map<String, Map<String, String?>> productDetailsCache = {};

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
  Future<void> _fetchChiTietSPBySupplier(String maNCC) async {
    try {
      List<ChiTietSP> fetchedChiTietSPs = await chiTietSPController.fetchAllChiTietSPByMaNCC(maNCC);

      // Fetch all product details at once and cache them
      for (var ctsp in fetchedChiTietSPs) {
        if (!productDetailsCache.containsKey(ctsp.maCTSP)) {
          productDetailsCache[ctsp.maCTSP] = await fetchProductDetails(ctsp);
        }
      }

      setState(() {
        chiTietSPs = fetchedChiTietSPs;
        quantities = List<int>.filled(chiTietSPs.length, 0);
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
    return productDetails;
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
            Text('${widget.newOrderCode}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Nhà cung cấp'),
            suppliers.isEmpty
                ? CircularProgressIndicator()
                : DropdownButton<String>(
              value: selectedSupplier,
              isExpanded: true,
              onChanged: _isOrderCreated ? null : (String? newValue) {  // Add this condition
                setState(() {
                  selectedSupplier = newValue;
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
                Text('${temporaryTotal.toStringAsFixed(0)}đ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: _isOrderCreated
                  ? ElevatedButton(
                onPressed: () {
                  PhieuNhap phieuNhap = PhieuNhap(
                    maPhieuNhap: widget.newOrderCode,
                    nhaCungCap: selectedSupplier!,
                    maNV: widget.maNV,
                    tongTien: getTotalAmount(),
                    ngayDat: DateTime.now(),
                    trangThai: 'Đang xử lý',
                  );

                  List<Map<String, dynamic>> selectedProductsWithQuantities = [];
                  for (int i = 0; i < chiTietSPs.length; i++) {
                    if (selectedItems[chiTietSPs[i].maCTSP] == true && quantities[i] > 0) {
                      selectedProductsWithQuantities.add({
                        'product': chiTietSPs[i],
                        'quantity': quantities[i],
                      });
                    }
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventoryForm(
                        phieuNhap: phieuNhap,
                        selectedProductsWithQuantities: selectedProductsWithQuantities,
                      ),
                    ),
                  );
                },
                child: Text('Xác nhận (${quantities.where((q) => q > 0).length})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              )
                  : ElevatedButton(
                onPressed: _isCreating
                    ? null
                    : () async {
                  setState(() {
                    _isCreating = true;
                  });

                  PhieuNhap phieuNhap = PhieuNhap(
                    maPhieuNhap: widget.newOrderCode,
                    nhaCungCap: selectedSupplier!,
                    maNV: widget.maNV,
                    tongTien: 0,
                    ngayDat: DateTime.now(),
                    trangThai: 'Đang xử lý',
                  );

                  try {
                    PhieuNhap result = await phieuNhapController.taoPhieuNhap(phieuNhap);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tạo phiếu nhập thành công! Mã: ${result.maPhieuNhap}')),
                    );

                    setState(() {
                      _isOrderCreated = true;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi tạo phiếu nhập: $e')),
                    );
                  } finally {
                    setState(() {
                      _isCreating = false;
                    });
                  }
                },
                child: Text('Tạo phiếu nhập'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
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
    // Initialize the selection state for this item if it doesn't exist
    selectedItems.putIfAbsent(chiTietSP.maCTSP, () => false);

    // Get cached product details
    final productDetails = productDetailsCache[chiTietSP.maCTSP];

    if (productDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Checkbox(
            value: selectedItems[chiTietSP.maCTSP],
            onChanged: (bool? value) {
              setState(() {
                selectedItems[chiTietSP.maCTSP] = value ?? false;
                _updateTemporaryTotal();
              });
            },
          ),
          // Product Image
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: chiTietSP.maHinhAnh != null && chiTietSP.maHinhAnh.isNotEmpty
                  ? Image.network(
                storageService.getImageUrl(chiTietSP.maHinhAnh),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                    ),
                  );
                },
              )
                  : Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  utf8.decode(productDetails['productName']?.runes.toList() ?? []),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${utf8.decode(productDetails['size']?.runes.toList() ?? [])} - ${utf8.decode(productDetails['color']?.runes.toList() ?? [])}',
                ),
                Text(
                  '${chiTietSP.giaBan}đ',
                  style: TextStyle(color: Colors.red),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (quantities[index] > 0) quantities[index]--;
                          _updateTemporaryTotal();
                        });
                      },
                    ),
                    Text('${quantities[index]}'),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          quantities[index]++;
                          _updateTemporaryTotal();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _updateTemporaryTotal() {
    temporaryTotal = 0.0; // Reset tổng tạm tính
    for (int i = 0; i < chiTietSPs.length; i++) {
      if (selectedItems[chiTietSPs[i].maCTSP] == true) {
        temporaryTotal += quantities[i] * chiTietSPs[i].giaBan; // Tính tổng cho sản phẩm được chọn
      }
    }
    setState(() {}); // Cập nhật giao diện
  }
  // Helper method to get selected items count
  int get selectedItemsCount => selectedItems.values.where((selected) => selected).length;

  // Method to get list of selected ChiTietSP
  List<ChiTietSP> getSelectedProducts() {
    return chiTietSPs.where((ctsp) => selectedItems[ctsp.maCTSP] == true).toList();
  }
  double getTotalAmount() {
    double total = 0;
    for (int i = 0; i < chiTietSPs.length; i++) {
      if (quantities[i] > 0) {
        total += quantities[i] * chiTietSPs[i].giaBan; // Assuming giaBan is the price per unit
      }
    }
    return total;
  }


}