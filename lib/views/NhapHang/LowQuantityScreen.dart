import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
import '../../services/shared_function.dart';

class LowQuantityScreen extends StatefulWidget {
  @override
  _LowQuantityScreenState createState() => _LowQuantityScreenState();
}

class _LowQuantityScreenState extends State<LowQuantityScreen> {
  final ChiTietSPController chiTietSPController = ChiTietSPController();
  final DanhMucSPController danhMucSPController = DanhMucSPController();
  final NCCController nccController = NCCController();
  final StorageService storageService = StorageService();
  final SharedFunction sharedFunction = SharedFunction();
  final SanPhamController sanPhamController = SanPhamController();
  final MauSPController mauSPController = MauSPController();
  final KichCoController kichCoController = KichCoController();

  final TextEditingController searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChiTietSP> filteredProducts = [];
  List<DanhMucSP> categories = [];
  List<NhaCungCap> suppliers = [];
  Map<String, Map<String, String?>> productDetailsCache = {};

  String? selectedCategory;
  String? selectedSupplier;
  bool isLoading = false;
  bool isLoadingMore = false;
  Timer? _debounceTimer;

  int currentPage = 0;
  final int pageSize = 20; // Increased page size
  final int threshold = 10;
  bool hasMoreProducts = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      isLoading = true;
      currentPage = 0;
      hasMoreProducts = true;
    });

    try {
      final futures = await Future.wait([
        _fetchProducts(),
        danhMucSPController.fetchDanhMucSP(),
        nccController.fetchSuppliers(),
      ]);

      setState(() {
        filteredProducts = futures[0] as List<ChiTietSP>;
        categories = futures[1] as List<DanhMucSP>;
        suppliers = futures[2] as List<NhaCungCap>;
        isLoading = false;
      });

      // Pre-fetch details for the first page
      _prefetchProductDetails(filteredProducts);
    } catch (e) {
      print('Error fetching initial data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi tải dữ liệu')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<ChiTietSP>> _fetchProducts() async {
    if (!hasMoreProducts) return [];

    try {
      final newProducts = await chiTietSPController.searchProducts(
        tenSP: searchTextController.text,
        maDanhMuc: selectedCategory,
        maNCC: selectedSupplier,
        page: currentPage,
        size: pageSize,
      );

      currentPage++;
      hasMoreProducts = newProducts.length == pageSize;

      return newProducts;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  void _prefetchProductDetails(List<ChiTietSP> products) {
    for (var product in products) {
      if (!productDetailsCache.containsKey(product.maCTSP)) {
        _fetchProductDetails(product).then((details) {
          if (mounted) {
            setState(() {
              productDetailsCache[product.maCTSP] = details;
            });
          }
        });
      }
    }
  }

  Future<Map<String, String?>> _fetchProductDetails(ChiTietSP ctsp) async {
    Map<String, String?> details = {};
    try {
      final futures = await Future.wait([
        sanPhamController.getProductNameByMaSP(ctsp.maSP),
        kichCoController.layTenKichCo(ctsp.maKichCo),
        mauSPController.layTenMauByMaMau(ctsp.maMau),
        nccController.fetchSupById(ctsp.maNCC),
      ]);

      details['productName'] = futures[0] as String?;
      details['size'] = futures[1] as String?;
      details['color'] = futures[2] as String?;
      NhaCungCap? fetchSup = futures[3] as NhaCungCap?;
      details['sup'] = fetchSup?.tenNCC ?? ' ';
    } catch (e) {
      print('Error fetching product details: $e');
    }
    return details;
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      _applyFilters();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    if (isLoadingMore || !hasMoreProducts) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final newProducts = await _fetchProducts();
      if (mounted) {
        setState(() {
          filteredProducts.addAll(newProducts);
          isLoadingMore = false;
        });
      }
      _prefetchProductDetails(newProducts);
    } catch (e) {
      print('Error loading more products: $e');
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _applyFilters() async {
    setState(() {
      isLoading = true;
      currentPage = 0;
      hasMoreProducts = true;
      filteredProducts.clear();
    });

    try {
      final newProducts = await _fetchProducts();
      if (mounted) {
        setState(() {
          filteredProducts = newProducts;
          isLoading = false;
        });
      }
      _prefetchProductDetails(newProducts);
    } catch (e) {
      print('Error applying filters: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi lọc sản phẩm')),
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: searchTextController,
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
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Danh mục',
              border: OutlineInputBorder(),
            ),
            value: selectedCategory,
            items: [
              DropdownMenuItem(
                value: null,
                child: Text('Chọn danh mục'),
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
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Nhà cung cấp',
              border: OutlineInputBorder(),
            ),
            value: selectedSupplier,
            items: [
              DropdownMenuItem(
                value: null,
                child: Text('Chọn nhà cung cấp'),
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
        ],
      ),
    );
  }

  Widget _buildProductItem(ChiTietSP product) {
    final details = productDetailsCache[product.maCTSP];
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
        title: Text(details?['productName'] ?? 'Loading...'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${details?['size'] ?? 'Loading...'} - ${details?['color'] ?? 'Loading...'}'),
            Text(details?['sup'] ?? 'Loading...'),
            Text(
              'Số lượng: ${product.slKho}',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        trailing: Text(
          '${sharedFunction.formatCurrency(product.giaBan)}',
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
                  ? Center(child: Text('Chọn lựa tiêu chí lọc sản phẩm'))
                  : ListView.builder(
                controller: _scrollController,
                itemCount: filteredProducts.length + (hasMoreProducts ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < filteredProducts.length) {
                    return _buildProductItem(filteredProducts[index]);
                  } else if (hasMoreProducts) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

