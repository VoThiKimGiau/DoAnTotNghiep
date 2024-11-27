import 'dart:async';
import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/DanhSachPhieuNhap.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import '../../controllers/DanhMucSPController.dart';
import '../../models/ChiTietPhieuNhap.dart';
import '../../models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';

class ProductSelectionScreen extends StatefulWidget {
  final String maPhieuNhap;
  final String maNCC;
  final String maNV;

  ProductSelectionScreen({
    required this.maPhieuNhap,
    required this.maNCC,
    required this.maNV,
  });

  @override
  _ProductSelectionScreenState createState() => _ProductSelectionScreenState();
}
class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  final ChiTietSPController chiTietSPController = ChiTietSPController();
  final ChiTietPhieuNhapController chiTietPhieuNhapController=ChiTietPhieuNhapController();
  final StorageService storageService = StorageService();
  final MauSPController mauSPController = MauSPController();
  final KichCoController kichCoController = KichCoController();
  final SanPhamController sanPhamController = SanPhamController();
  final DanhMucSPController danhMucSPController = DanhMucSPController();
  Map<String, int> quantities = {};
  TextEditingController searchController = TextEditingController();
  List<DanhMucSP> categories = [];
  List<ChiTietSP> filteredProducts = [];
  List<ChiTietSP> chiTietSPs = [];
  Map<String, bool> selectedItems = {};
  Map<String, Map<String, String?>> productDetailsCache = {};
  double temporaryTotal = 0.0;
  String? selectedCategory;
  bool isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCategories();

  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await danhMucSPController.fetchDanhMucSP();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
  Future<Map<String, String?>> fetchProductDetails(ChiTietSP ctsp) async {
    Map<String, String?> details = {};
    try {
      details['productName'] = await sanPhamController.getProductNameByMaSP(ctsp.maSP);
      details['size'] = await kichCoController.layTenKichCo(ctsp.maKichCo);
      details['color'] = await mauSPController.layTenMauByMaMau(ctsp.maMau);
    } catch (e) {
      print('Error fetching product details: $e');
    }
    return details;
  }

  Future<void> _fetchProducts() async {
    try {
      List<ChiTietSP> fetchedProducts = await chiTietSPController.fetchAllChiTietSPByMaNCC(widget.maNCC);

      for (var ctsp in fetchedProducts) {
        if (!productDetailsCache.containsKey(ctsp.maCTSP)) {
          productDetailsCache[ctsp.maCTSP] = await fetchProductDetails(ctsp);
        }
      }

      setState(() {
        chiTietSPs = fetchedProducts;
        filteredProducts = fetchedProducts;
        for (var product in chiTietSPs) {
          quantities[product.maCTSP] = 0;
        }
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> _searchProducts(String query, {String? maDanhMuc}) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<ChiTietSP> searchResults = [];
      List<ChiTietSP> supplierProducts = await chiTietSPController.fetchAllChiTietSPByMaNCC(widget.maNCC);
      if (maDanhMuc != null) {
        final categoryProducts = await chiTietSPController.fetchChiTietSPByCategory(maDanhMuc);
        final categoryProductIds = categoryProducts.map((item) => ChiTietSP.fromJson(item).maCTSP).toSet();
        supplierProducts = supplierProducts.where((product) =>
            categoryProductIds.contains(product.maCTSP)).toList();
      }

      if (query.isNotEmpty) {
        final searchedProducts = await chiTietSPController.fetchChiTietSPByTenSanPham(query);
        final searchedProductIds = searchedProducts.map((item) =>
        ChiTietSP.fromJson(item).maCTSP).toSet();

        // Lọc sản phẩm có trong kết quả tìm kiếm
        searchResults = supplierProducts.where((product) =>
            searchedProductIds.contains(product.maCTSP)).toList();
      } else {
        // Nếu không có query, sử dụng danh sách đã lọc theo danh mục
        searchResults = supplierProducts;
      }

      // 4. Fetch product details cho các sản phẩm đã lọc
      for (var ctsp in searchResults) {
        if (!productDetailsCache.containsKey(ctsp.maCTSP)) {
          try {
            productDetailsCache[ctsp.maCTSP] = await fetchProductDetails(ctsp);
          } catch (e) {
            print('Error fetching product details for ${ctsp.maCTSP}: $e');
          }
        }
      }

      setState(() {
        filteredProducts = searchResults;
        isLoading = false;
      });
    } catch (e) {
      print('Error searching products: $e');
      setState(() {
        isLoading = false;
        filteredProducts = [];
      });
    }
  }

// Hàm debounce để tránh gọi API quá nhiều
  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _searchProducts(query, maDanhMuc: selectedCategory);
    });
  }

  Widget _buildCategoryList() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.maDanhMuc;

          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                category.tenDanhMuc,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = selected ? category.maDanhMuc : null;
                  searchController.clear();
                  _searchProducts('', maDanhMuc: selectedCategory);
                });
              },
            ),
          );
        },
      ),
    );
  }
  void _updateTemporaryTotal() {
    temporaryTotal = 0.0;
    for (var product in filteredProducts) {
      if (selectedItems[product.maCTSP] == true) {
        temporaryTotal += (quantities[product.maCTSP] ?? 0) * product.giaBan;
      }
    }
    setState(() {});
  }

  Widget _buildProductEntry(int index, ChiTietSP chiTietSP) {
    selectedItems.putIfAbsent(chiTietSP.maCTSP, () => false);
    quantities.putIfAbsent(chiTietSP.maCTSP, () => 0); // Ensure quantity exists
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
          Checkbox(
            value: selectedItems[chiTietSP.maCTSP],
            onChanged: (bool? value) {
              setState(() {
                selectedItems[chiTietSP.maCTSP] = value ?? false;
                _updateTemporaryTotal();
              });
            },
          ),
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
                    child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                  );
                },
              )
                  : Container(
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productDetails['productName'] ?? '',

                ),
                Text(
                  '${(productDetails['size'] ?? [])} - ${productDetails['color'] ?? ''}',
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
                          if (quantities[chiTietSP.maCTSP]! > 0) {
                            quantities[chiTietSP.maCTSP] = quantities[chiTietSP.maCTSP]! - 1;
                            _updateTemporaryTotal();
                          }
                        });
                      },
                    ),
                    Text('${quantities[chiTietSP.maCTSP]}'),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          quantities[chiTietSP.maCTSP] = (quantities[chiTietSP.maCTSP] ?? 0) + 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn sản phẩm', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã phiếu nhập: ${widget.maPhieuNhap}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: isLoading
                    ? Container(
                  width: 24,
                  height: 24,
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _searchProducts('');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: 16),
            // Category List
            _buildCategoryList(),
            Expanded(

              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? Center(child: Text('Không tìm thấy sản phẩm nào'))
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  print("Filtered Products: $filteredProducts");
                  return _buildProductEntry(
                    chiTietSPs.indexOf(product),
                    product,
                  );
                },
              ),
            ),
            // Bottom section with total and confirm button
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tạm tính:', style: TextStyle(fontSize: 18)),
                Text(
                  '${temporaryTotal.toStringAsFixed(0)}đ',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  _showConfirmationDialog();
                },
                child: Text('Xác nhận (${quantities.entries.where((entry) => entry.value > 0).length})'),
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
  void _addChiTietPhieuNhap()  async{
    PhieuNhap phieuNhap = PhieuNhap(
      maPhieuNhap: widget.maPhieuNhap,
      nhaCungCap: widget.maNCC,
      maNV: widget.maNV,
      tongTien: temporaryTotal,
      ngayDat: DateTime.now(),
      trangThai: 'Đang xử lý',
    );

    List<ChiTietPhieuNhap> danhSachChiTiet = [];
    // Iterate over the selected items
    for (var entry in selectedItems.entries) {
      if (entry.value && quantities[entry.key] != null && quantities[entry.key]! > 0) {
        // Ensure 'entry.key' exists in the 'quantities' map
        final chiTietSP = chiTietSPs.firstWhere((ctsp) => ctsp.maCTSP == entry.key);
        ChiTietPhieuNhap chiTiet = ChiTietPhieuNhap(
          maPN: widget.maPhieuNhap,
          maCTSP: chiTietSP.maCTSP, // Add the 'maSP' from the matching ChiTietSP
          soLuong: quantities[entry.key]!,
          donGia: chiTietSP.giaBan,
        );
        danhSachChiTiet.add(chiTiet);
      }
    }

    // Call `themNhieuChiTietPhieuNhap` and wait for the results
    try {
      List<ChiTietPhieuNhap> ketQua = await chiTietPhieuNhapController.themNhieuChiTietPhieuNhap(danhSachChiTiet);
      if (ketQua.isNotEmpty) {
        // Success - Show a message or navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm chi tiết phiếu nhập thành công!')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseOrderList(maNV: widget.maNV)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không có sản phẩm nào được thêm.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Không cho phép đóng dialog khi bấm ngoài khu vực dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn thêm chi tiết phiếu nhập?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Đóng dialog và không làm gì
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Thực hiện thêm Chi Tiết Phiếu Nhập tại đây
                _addChiTietPhieuNhap();
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

}