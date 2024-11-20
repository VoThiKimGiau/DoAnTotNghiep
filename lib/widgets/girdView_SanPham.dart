import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import '../controllers/SPYeuThichController.dart';
import '../models/SPYeuThich.dart';

class GridViewSanPham extends StatefulWidget {
  final List<SanPham> itemsSP;
  final String? maKH;

  GridViewSanPham({
    Key? key,
    required this.itemsSP,
    this.maKH,
  }) : super(key: key);

  @override
  _GridViewSanPhamState createState() => _GridViewSanPhamState();
}

class _GridViewSanPhamState extends State<GridViewSanPham> {
  SPYeuThichController spYeuThichController = SPYeuThichController();
  List<SPYeuThich> dsSPYT = [];
  late List<bool> isFavoriteList;

  @override
  void initState() {
    super.initState();
    isFavoriteList = List.filled(widget.itemsSP.length, false);
    fetchSPYeuThich(widget.maKH);
  }

  Future<void> fetchSPYeuThich(String? maKH) async {
    try {
      List<SPYeuThich> fetchedItems =
          await spYeuThichController.fetchSPYeuThichByKH(maKH);
      setState(() {
        dsSPYT = fetchedItems;
        isFavoriteList = List.generate(widget.itemsSP.length, (index) {
          return dsSPYT
              .any((spyt) => spyt.maSanPham == widget.itemsSP[index].maSP);
        });
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        dsSPYT = []; // Set list to empty on error
        isFavoriteList = List.filled(widget.itemsSP.length, false);
      });
    }
  }

  Future<void> toggleFavorite(int index) async {
    var product = widget.itemsSP[index];
    if (!isFavoriteList[index]) {
      await spYeuThichController.themSPYeuThich(
        SPYeuThich(
          maKhachHang: widget.maKH ?? '',
          maSanPham: product.maSP,
        ),
      );
      setState(() {
        isFavoriteList[index] = true;
      });
      print('Sản phẩm đã được thêm vào yêu thích.');
    } else {
      await spYeuThichController.xoaSPYeuThich(widget.maKH ?? '', product.maSP);
      setState(() {
        isFavoriteList[index] = false;
      });
      print('Sản phẩm đã được xóa khỏi danh sách yêu thích.');
    }
  }

  @override
  Widget build(BuildContext context) {
    StorageService storageService = StorageService();
    SharedFunction sharedFunction = SharedFunction();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 5, // Spacing between columns
        mainAxisSpacing: 5, // Spacing between rows
        childAspectRatio: 0.8, // Aspect ratio of each cell
      ),
      itemCount: widget.itemsSP.length,
      itemBuilder: (context, index) {
        final product = widget.itemsSP[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChiTietSanPhamScreen(
                  maSP: product.maSP,
                  maKH: widget.maKH,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Card(
                color: Colors.white,
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(storageService
                                .getImageUrl(product.hinhAnhMacDinh)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          product.tenSP,
                          style: const TextStyle(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Text(
                          sharedFunction.formatCurrency(product.giaMacDinh),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gabarito',
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 1,
                right: 1,
                child: ElevatedButton(
                  onPressed: () => toggleFavorite(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(18, 18),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: SvgPicture.asset(
                    isFavoriteList[index]
                        ? 'assets/icons/heart_red.svg'
                        : 'assets/icons/heart.svg',
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
