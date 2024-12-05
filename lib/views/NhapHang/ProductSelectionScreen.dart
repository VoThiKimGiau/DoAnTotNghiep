import 'dart:async';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietPhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/DanhMucSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhaCungCapController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/PhieuNhapController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietPhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/models/DanhMucSP.dart';
import 'package:datn_cntt304_bandogiadung/models/NhaCungCap.dart';
import 'package:datn_cntt304_bandogiadung/models/PhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/DanhSachPhieuNhap.dart';
import 'package:datn_cntt304_bandogiadung/colors/color.dart';

import '../../models/SanPham.dart';

class ProductSelectionScreen extends StatefulWidget {
  final String maPhieuNhap;
  final String maNV;

  ProductSelectionScreen({
    required this.maPhieuNhap,
    required this.maNV,
  });

  @override
  _ProductSelectionScreenState createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  final ChiTietSPController chiTietSPController = ChiTietSPController();
  final ChiTietPhieuNhapController chiTietPhieuNhapController = ChiTietPhieuNhapController();
  final StorageService storageService = StorageService();
  final MauSPController mauSPController = MauSPController();
  final KichCoController kichCoController = KichCoController();
  final SanPhamController sanPhamController = SanPhamController();
  final DanhMucSPController danhMucSPController = DanhMucSPController();
  final NCCController nccController = NCCController();
  final PhieuNhapController phieuNhapController = PhieuNhapController();
  final NCCController nhaCungCapController=NCCController();
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<DanhMucSP> categories = [];
  List<NhaCungCap> suppliers = [];
  List<ChiTietSP> filteredProducts = [];
  Map<String, int> quantities = {};
  Map<String, bool> selectedItems = {};
  Map<String, Map<String, String?>> productDetailsCache = {};
  SharedFunction sharedFunction=SharedFunction();
  String? selectedCategory;
  String? selectedSupplier;
  bool isLoading = false;
  bool allItemsLoaded = false;
  int currentPage = 0;
  final int pageSize = 20;
  double temporaryTotal = 0.0;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _fetchCategories(),
      _fetchSuppliers(),
    ]);
    await _fetchProducts();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await danhMucSPController.fetchDanhMucSP();
      if (mounted) {
        setState(() {
          categories = fetchedCategories;
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _fetchSuppliers() async {
    try {
      final fetchedSuppliers = await nccController.fetchSuppliers();
      if (mounted) {
        setState(() {
          suppliers = fetchedSuppliers;
        });
      }
    } catch (e) {
      print('Error fetching suppliers: $e');
    }
  }

  Future<void> _fetchProducts() async {
    if (isLoading || allItemsLoaded) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newProducts = await chiTietSPController.searchProducts(
        tenSP: searchController.text,
        maDanhMuc: selectedCategory,
        maNCC: selectedSupplier,
        page: currentPage,
        size: pageSize,
      );

      if (mounted) {
        setState(() {
          if (newProducts.isEmpty) {
            allItemsLoaded = true;
          } else {
            if (currentPage == 0) {
              filteredProducts = newProducts;
            } else {
              filteredProducts.addAll(newProducts);
            }
            currentPage++;
          }
          isLoading = false;
        });
      }

      _fetchProductDetailsInBackground(newProducts);
    } catch (e) {
      print('Error fetching products: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _fetchProductDetailsInBackground(List<ChiTietSP> products) {
    for (var product in products) {
      if (!productDetailsCache.containsKey(product.maCTSP)) {
        fetchProductDetails(product).then((details) {
          if (mounted) {
            setState(() {
              productDetailsCache[product.maCTSP] = details;
            });
          }
        });
      }
    }
  }

  Future<Map<String, String?>> fetchProductDetails(ChiTietSP ctsp) async {
    Map<String, String?> details = {};

    try {
      SanPham sp=await sanPhamController.getProductByMaSP(ctsp.maSP);
      final futures = await Future.wait([
        sanPhamController.getProductNameByMaSP(ctsp.maSP),
        kichCoController.layTenKichCo(ctsp.maKichCo),
        mauSPController.layTenMauByMaMau(ctsp.maMau),
        nhaCungCapController.fetchSupplierNameById(ctsp.maNCC),
        danhMucSPController.fetchTenDM(sp.danhMuc)
      ]);
      details['productName'] = futures[0] as String?;
      details['size'] = futures[1] as String?;
      details['color'] = futures[2] as String?;
      details['sup']=futures[3] as String?;
      details['cate']=futures[4] as String?;;

    } catch (e) {
      print('Error fetching product details: $e');
    }
    return details;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoading) {
      _fetchProducts();
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        currentPage = 0;
        allItemsLoaded = false;
        filteredProducts.clear();
      });
      _fetchProducts();
    });
  }

  void _updateTemporaryTotal() {
    temporaryTotal = filteredProducts.where((product) => selectedItems[product.maCTSP] == true)
        .fold(0.0, (sum, product) => sum + (quantities[product.maCTSP] ?? 0) * product.giaBan);
    setState(() {});
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
                  currentPage = 0;
                  allItemsLoaded = false;
                  filteredProducts.clear();
                });
                _fetchProducts();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSupplierDropdown() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSupplier,
          isExpanded: true,
          hint: Text('Chọn nhà cung cấp'),
          padding: EdgeInsets.symmetric(horizontal: 12),
          onChanged: (String? newValue) {
            setState(() {
              selectedSupplier = newValue;
              currentPage = 0;
              allItemsLoaded = false;
              filteredProducts.clear();
            });
            _fetchProducts();
          },
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text('Tất cả nhà cung cấp'),
            ),
            ...suppliers.map<DropdownMenuItem<String>>((NhaCungCap supplier) {
              return DropdownMenuItem<String>(
                value: supplier.maNCC,
                child: Text(supplier.tenNCC),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductEntry(ChiTietSP chiTietSP) {
    selectedItems.putIfAbsent(chiTietSP.maCTSP, () => false);
    quantities.putIfAbsent(chiTietSP.maCTSP, () => 0);
    final productDetails = productDetailsCache[chiTietSP.maCTSP];

    if (productDetails == null) {
      return SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
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
                Text(productDetails['cate'] ?? ''),
                Text(productDetails['productName'] ?? ''),
                Text('${(productDetails['size'] ?? '')} - ${productDetails['color'] ?? ''}'),
                Text(
                  ' ${sharedFunction.formatCurrency( chiTietSP.giaBan)}',
                  style: TextStyle(color: Colors.red),
                ),
                Text(productDetails['sup'] ?? ''),
                Text('Số lượng kho:'+chiTietSP.slKho.toString()),
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
            _buildSupplierDropdown(),
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
            _buildCategoryList(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredProducts.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < filteredProducts.length) {
                    return _buildProductEntry(filteredProducts[index]);
                  } else if (isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tạm tính:', style: TextStyle(fontSize: 18)),
                Text(
                  '${sharedFunction.formatCurrency(temporaryTotal) }',
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
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor:Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addChiTietPhieuNhap() async {
    if (selectedSupplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn nhà cung cấp')),
      );
      return;
    }

    PhieuNhap phieuNhap = PhieuNhap(
      maPhieuNhap: widget.maPhieuNhap,
      nhaCungCap: selectedSupplier!,
      maNV: widget.maNV,
      tongTien: temporaryTotal,
      ngayDat: DateTime.now(),
      trangThai: 'Đang xử lý',
    );

    try {
      await phieuNhapController.taoPhieuNhap(phieuNhap);

      List<ChiTietPhieuNhap> danhSachChiTiet = [];
      for (var entry in selectedItems.entries) {
        if (entry.value && quantities[entry.key] != null && quantities[entry.key]! > 0) {
          final chiTietSP = filteredProducts.firstWhere((ctsp) => ctsp.maCTSP == entry.key);
          ChiTietPhieuNhap chiTiet = ChiTietPhieuNhap(
            maPN: widget.maPhieuNhap,
            maCTSP: chiTietSP.maCTSP,
            soLuong: quantities[entry.key]!,
            donGia: chiTietSP.giaBan,
          );
          danhSachChiTiet.add(chiTiet);
        }
      }

      List<ChiTietPhieuNhap> ketQua = await chiTietPhieuNhapController.themNhieuChiTietPhieuNhap(danhSachChiTiet);
      if (ketQua.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm chi tiết phiếu nhập thành công!')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PurchaseOrderList(maNV: widget.maNV)));
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn thêm chi tiết phiếu nhập?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                _addChiTietPhieuNhap();
                Navigator.of(context).pop();
              },
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }
}

