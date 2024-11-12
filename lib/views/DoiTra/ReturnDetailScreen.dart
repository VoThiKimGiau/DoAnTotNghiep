import 'dart:convert';

import 'package:datn_cntt304_bandogiadung/controllers/VatChungDoiTraController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/ChiTietSPController.dart';
import '../../controllers/DoiTraController.dart';
import '../../controllers/KichCoController.dart';
import '../../controllers/MauSPController.dart';
import '../../controllers/SanPhamController.dart';
import '../../models/ChiTietDoiTra.dart';
import '../../models/DoiTra.dart';
import '../../models/VatChungDoiTra.dart';
import '../../services/storage/storage_service.dart';


class ReturnDetailScreen extends StatefulWidget {
  final DoiTra doiTra;

  ReturnDetailScreen({required this.doiTra});

  @override
  _ReturnDetailScreenState createState() => _ReturnDetailScreenState();
}

class _ReturnDetailScreenState extends State<ReturnDetailScreen> {
  final DoiTraController _doiTraController = DoiTraController();
  final ChiTietSPController _chiTietSPController = ChiTietSPController();
  final MauSPController _mauSPController = MauSPController();
  final KichCoController _kichCoController = KichCoController();
  final SanPhamController _sanPhamController = SanPhamController();
  final VatChungDoiTraController _vatChungDoiTraController=VatChungDoiTraController();
  final StorageService _storageService = StorageService();

  late Future<List<ChiTietDoiTra>> _chiTietDoiTraList;
  late Future<List<VatChungDoiTra>> _vatChungDoiTraList;

  @override
  void initState() {
    super.initState();
    _chiTietDoiTraList = _doiTraController.getChiTietDoiTra(widget.doiTra.maDoiTra);
    _vatChungDoiTraList = _vatChungDoiTraController.getAllVatChungDoiTra(maDoiTra: widget.doiTra.maDoiTra);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đổi trả', style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReturnInfo(),
              SizedBox(height: 20),
              Text('Sản phẩm đổi trả:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              _buildReturnedProductsList(),
              SizedBox(height: 20),
              Text('Vật chứng đổi trả:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              _buildEvidenceList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReturnInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã đổi trả: ${widget.doiTra.maDoiTra}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Đơn hàng: ${widget.doiTra.donHang}', style: TextStyle(fontSize: 18)),
            Text('Trạng thái: ${utf8.decode( widget.doiTra.trangThai.runes.toList())}', style: TextStyle(fontSize: 18)),
            Text('Ngày đổi trả: ${DateFormat('dd/MM/yyyy').format(widget.doiTra.ngayDoiTra ?? DateTime.now())}', style: TextStyle(fontSize: 18)),
            Text('Lý do: ${widget.doiTra.lyDo}', style: TextStyle(fontSize: 18)),
            Text('Tiền hoàn trả: ${NumberFormat.currency(locale: 'vi').format(widget.doiTra.tienHoanTra)}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnedProductsList() {
    return FutureBuilder<List<ChiTietDoiTra>>(
      future: _chiTietDoiTraList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có sản phẩm đổi trả.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            ChiTietDoiTra chiTiet = snapshot.data![index];
            return FutureBuilder<Widget>(
              future: _buildProductItem(chiTiet),
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (productSnapshot.hasError) {
                  return Text('Lỗi: ${productSnapshot.error}');
                } else {
                  return productSnapshot.data ?? Container();
                }
              },
            );
          },
        );
      },
    );
  }

  Future<Widget> _buildProductItem(ChiTietDoiTra chiTiet) async {
    try {
      final chiTietSP = await _chiTietSPController.layCTSPTheoMa(chiTiet.maCTSP);
      final tenSP = await _sanPhamController.getProductNameByMaSP(chiTietSP.maSP);
      final tenMau = await _mauSPController.layTenMauByMaMau(chiTietSP.maMau);
      final tenKichCo = await _kichCoController.layTenKichCo(chiTietSP.maKichCo);
      final imageUrl = _storageService.getImageUrl(chiTietSP.maHinhAnh);

      return Card(
        child: ListTile(
          leading: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
          title: Text('${chiTiet.maCTSP}\n$tenSP - $tenMau - ${utf8.decode(tenKichCo.runes.toList())}', style: TextStyle(fontSize: 18)),
          subtitle: Text('Số lượng: ${chiTiet.soluong}\n Giá: ${NumberFormat.currency(locale: 'vi').format(chiTiet.gia)}', style: TextStyle(fontSize: 16)),
        ),
      );
    } catch (e) {
      return Text('Lỗi khi tải thông tin sản phẩm: $e');
    }
  }


  Widget _buildEvidenceList() {
    return FutureBuilder<List<VatChungDoiTra>>(
      future: _vatChungDoiTraList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có vật chứng đổi trả.'));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            VatChungDoiTra vatChung = snapshot.data![index];
            return FutureBuilder<String?>(
              future: _storageService.getVCDTImage(vatChung.maVatChung.trim()),
              builder: (context, urlSnapshot) {
                if (urlSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (urlSnapshot.hasError) {
                  return Center(child: Icon(Icons.error));
                } else if (!urlSnapshot.hasData || urlSnapshot.data == null) {
                  return Center(child: Text('Không tìm thấy ảnh'));
                }

                String imageUrl = urlSnapshot.data!;
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('Vật chứng ${vatChung.maVatChung}'),
                          backgroundColor: Colors.black,
                        ),
                        body: Center(
                          child: InteractiveViewer(
                            panEnabled: false,
                            boundaryMargin: EdgeInsets.all(100),
                            minScale: 0.5,
                            maxScale: 2,
                            child: Image.network(
                              imageUrl,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ));
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Mã: ${vatChung.maVatChung}', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}