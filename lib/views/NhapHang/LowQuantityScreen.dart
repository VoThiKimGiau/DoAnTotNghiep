import 'dart:async';
import 'package:flutter/material.dart';

import '../../controllers/ChiTietSPController.dart';
import '../../controllers/DanhMucSPController.dart';
import '../../controllers/KichCoController.dart';
import '../../controllers/MauSPController.dart';
import '../../controllers/NhaCungCapController.dart';
import '../../controllers/SanPhamController.dart';
import '../../models/ChiTietSP.dart';
import '../../models/DanhMucSP.dart';
import '../../models/NhaCungCap.dart';
import '../../services/storage/storage_service.dart';
class LowQuantityScreen extends StatefulWidget {
  @override
  _LowQuantityScreenState createState() => _LowQuantityScreenState();
}

class _LowQuantityScreenState extends State<LowQuantityScreen> {
  final ChiTietSPController chiTietSPController = ChiTietSPController();
  final DanhMucSPController danhMucSPController = DanhMucSPController();
  final NCCController nccController = NCCController();
  final StorageService storageService = StorageService();
  final SanPhamController sanPhamController = SanPhamController();
  late MauSPController mauSPController=MauSPController();
  late KichCoController kichCoController=KichCoController();
  TextEditingController searchController = TextEditingController();
  List<ChiTietSP> filteredProducts = [];
  List<DanhMucSP> categories = [];
  List<NhaCungCap> suppliers = [];
  Map<String, Map<String, String?>> productDetailsCache = {};

  String? selectedCategory;
  String? selectedSupplier;
  bool isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch all required data in parallel
      final futures = await Future.wait([
        chiTietSPController.fetchLowQuantity(),
        danhMucSPController.fetchDanhMucSP(),
        nccController.fetchSuppliers(),
      ]);

      // Lấy danh sách sản phẩm sắp hết hàng
      final lowQuantityProducts = futures[0] as List<ChiTietSP>;

      setState(() {
        filteredProducts = lowQuantityProducts;
        categories = futures[1] as List<DanhMucSP>;
        suppliers = futures[2] as List<NhaCungCap>;
      });

      // Cập nhật cache
      for (var product in lowQuantityProducts) {
        if (!productDetailsCache.containsKey(product.maCTSP)) {
          productDetailsCache[product.maCTSP] = await fetchProductDetails(product);
        }
      }
    } catch (e) {
      print('Error fetching initial data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi tải dữ liệu')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _applyFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Lấy danh sách các sản phẩm sắp hết hàng ban đầu
      List<ChiTietSP> lowQuantityProducts = await chiTietSPController.fetchLowQuantity();
      List<ChiTietSP> results = lowQuantityProducts;

      // 1. Lọc theo danh mục nếu có
      if (selectedCategory != null) {
        List<dynamic> categoryProducts = await chiTietSPController.fetchChiTietSPByCategory(selectedCategory!);
        Set<String> categoryProductIds = categoryProducts
            .map((item) => item['maSanPham'].toString())
            .toSet();

        results = results.where((product) =>
            categoryProductIds.contains(product.maSP)).toList();
      }

      // 2. Lọc theo nhà cung cấp nếu có
      if (selectedSupplier != null) {
        results = results.where((product) =>
        product.maNCC == selectedSupplier).toList();
      }

      // 3. Lọc theo từ khóa tìm kiếm nếu có
      final searchQuery = searchController.text.toLowerCase();
      if (searchQuery.isNotEmpty) {
        results = results.where((product) {
          final details = productDetailsCache[product.maCTSP];
          final productName = details?['productName']?.toLowerCase() ?? '';
          return productName.contains(searchQuery);
        }).toList();
      }

      // Cập nhật cache cho các sản phẩm mới
      for (var product in results) {
        if (!productDetailsCache.containsKey(product.maCTSP)) {
          productDetailsCache[product.maCTSP] = await fetchProductDetails(product);
        }
      }

      setState(() {
        filteredProducts = results;
      });
    } catch (e) {
      print('Error applying filters: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi lọc sản phẩm')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _applyFilters();
    });
  }

  Future<Map<String, String?>> fetchProductDetails(ChiTietSP ctsp) async {
    Map<String, String?> details = {};
    try {
      details['productName'] = await sanPhamController.getProductNameByMaSP(ctsp.maSP);
      details['size'] = await kichCoController.layTenKichCo(ctsp.maKichCo);
      details['color'] = await mauSPController.layTenMauByMaMau(ctsp.maMau);
      NhaCungCap? fetchSup= await nccController.fetchSupById(ctsp.maNCC);
      if(fetchSup!=null)
        {
          details['sup']=fetchSup.tenNCC;
        }
      else
        {
          details['sup']=' ';
        }

    } catch (e) {
      print('Error fetching product details: $e');
    }
    return details;
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm sản phẩm...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _onSearchChanged,
          ),
          SizedBox(height: 16),
          // First Row for Category Dropdown
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Danh mục',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCategory,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Tất cả danh mục'),
                    ),
                    ...categories.map((category) => DropdownMenuItem(
                      value: category.maDanhMuc,
                      child: Text(category.tenDanhMuc),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      _applyFilters();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16), // Add spacing between rows
          // Second Row for Supplier Dropdown
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Nhà cung cấp',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedSupplier,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Tất cả NCC'),
                    ),
                    ...suppliers.map((supplier) => DropdownMenuItem(
                      value: supplier.maNCC,
                      child: Text(supplier.tenNCC),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedSupplier = value;
                      _applyFilters();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(ChiTietSP product) {
    final details = productDetailsCache[product.maCTSP];
    if (details == null) return SizedBox.shrink();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          child: product.maHinhAnh != null && product.maHinhAnh.isNotEmpty
              ? Image.network(
            storageService.getImageUrl(product.maHinhAnh),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
          )
              : Icon(Icons.image_not_supported),
        ),
        title: Text(details['productName'] ?? 'Unknown'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${details['size'] ?? ''} - ${details['color'] ?? ''}'),
            Text('${details['sup']}'),
            Text(
              'Số lượng: ${product.slKho}',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Text(
          '${product.giaBan}đ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm sắp hết hàng'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchInitialData,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFilters(),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? Center(child: Text('Không có sản phẩm nào'))
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) => _buildProductItem(filteredProducts[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}