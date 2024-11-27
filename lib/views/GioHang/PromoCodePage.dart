import 'package:datn_cntt304_bandogiadung/controllers/KMKHController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KhuyenMaiController.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/controllers/CheckoutController.dart';
import 'package:datn_cntt304_bandogiadung/models/Promotion.dart';
import 'package:datn_cntt304_bandogiadung/models/KMKH.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/Widgets/promotion_item.dart';
import 'package:datn_cntt304_bandogiadung/colors/color.dart';

class PromoCodePage extends StatefulWidget {
  String? maKH;
  String? selectedCodeType1;
  String? selectedCodeType2;
  String? selectedName1;
  String? selectedName2;
  String? value1;
  String? value2;

  PromoCodePage(
      {super.key,
      required this.maKH,
      required this.selectedCodeType1,
      required this.selectedCodeType2,
      required this.selectedName1,
      required this.selectedName2,
      required this.value1,
      required this.value2});

  @override
  _PromoCodePageState createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
  List<Promotion> promotionsType1 = [];
  List<Promotion> promotionsType2 = [];

  CheckoutController checkoutController = CheckoutController();
  bool isLoading = true;

  KMKHController kmkhController = KMKHController();
  int? SLCon1;
  int? SLCon2;

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  _loadPromotions() async {
    try {
      List<KMKH> fetchItems = await checkoutController.fetchKMKH(widget.maKH!);
      List<Future<Promotion>> fetchKMDetailsFutures = [];
      List<KMKH> itemsToRemove = [];

      for (KMKH item in fetchItems) {
        if (item.soluong == 0) {
          await kmkhController.deleteKhuyenMaiKhachHang(
              widget.maKH!, item.khuyenMai!);
          itemsToRemove.add(item);
        }
      }

      fetchItems.removeWhere((item) => itemsToRemove.contains(item));

      // Prepare futures for fetching details concurrently
      for (KMKH promo in fetchItems) {
        fetchKMDetailsFutures
            .add(checkoutController.fetchDetailKM(promo.khuyenMai ?? ''));
      }

      // Wait for all futures to complete
      List<Promotion> fetchKMDetails = await Future.wait(fetchKMDetailsFutures);

      List<Promotion> fetchKMType1 = [];
      List<Promotion> fetchKMType2 = [];

      DateTime today = DateTime.now();
      for (Promotion km in fetchKMDetails) {
        if (km.ngayKetThuc.isBefore(today)) {
          await kmkhController.deleteKhuyenMaiKhachHang(widget.maKH!, km.maKm);
        } else {
          if (km.loaiKm == 'Phí vận chuyển') {
            fetchKMType1.add(km);
          } else if (km.loaiKm == 'Giá trị đơn') {
            fetchKMType2.add(km);
          }
        }
      }

      setState(() {
        promotionsType1 = fetchKMType1;
        promotionsType2 = fetchKMType2;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        promotionsType1 = [];
        promotionsType2 = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chọn mã khuyến mãi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, [
            widget.selectedCodeType1,
            widget.selectedCodeType2,
            widget.selectedName1,
            widget.selectedName2,
            widget.value1,
            widget.value2
          ]),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: double.infinity,
                    child: const Text(
                      'Phí vận chuyển',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gabarito'),
                      textAlign: TextAlign.left,
                    )),
                Expanded(
                  child: ListView(
                    children: promotionsType1.map((promo) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            widget.selectedCodeType1 = promo.maKm;
                            widget.selectedName1 = promo.moTa;
                            widget.value1 = promo.triGiaGiam.toString();
                          });
                        },
                        child: PromotionItem(
                          promotion: promo,
                          isSelect: widget.selectedCodeType1 == promo.maKm,
                          maKH: widget.maKH,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: double.infinity,
                    child: const Text(
                      'Giá trị đơn',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gabarito'),
                      textAlign: TextAlign.left,
                    )),
                Expanded(
                  child: ListView(
                    children: promotionsType2.map((promo) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            widget.selectedCodeType2 = promo.maKm;
                            widget.selectedName2 = promo.moTa;
                            widget.value2 = promo.triGiaGiam.toString();
                          });
                        },
                        child: PromotionItem(
                          promotion: promo,
                          isSelect: widget.selectedCodeType2 == promo.maKm,
                          maKH: widget.maKH,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, [
              widget.selectedCodeType1,
              widget.selectedCodeType2,
              widget.selectedName1,
              widget.selectedName2,
              widget.value1,
              widget.value2
            ]);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'Tiếp tục',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
