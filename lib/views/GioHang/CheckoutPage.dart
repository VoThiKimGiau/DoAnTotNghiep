import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/CheckoutController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietGioHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/GiaoHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KMDHController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/SanPhamController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietDonHang.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import '../../controllers/KichCoController.dart';
import '../../controllers/MauSPController.dart';
import '../../models/KMDH.dart';
import '../../services/shared_function.dart';
import 'PaymentMethodPage.dart';
import 'PromoCodePage.dart';
import 'SelectAddressPage.dart';
import 'ShippingMethodPage.dart';
import 'SuccessPage.dart';
import '../../controllers/TTNhanHangController.dart';
import '../../models/TTNhanHang.dart';

class CheckoutPage extends StatefulWidget {
  final List<ChiTietSP> dsSP;
  final String? customerId;
  final List<int> slMua;
  final String maGH;
  final String muaTu;

  const CheckoutPage({
    super.key,
    required this.dsSP,
    required this.customerId,
    required this.slMua,
    required this.maGH,
    required this.muaTu,
  }); // Cập nhật constructor

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Here.com
  // Mail: cuahanggiadunghuit@gmail.com
  // Pass: Cntt304cuahanggiadunghuit@
  // App ID: KnDuhWETcgnVcmXRXS2G
  // API Key: 8AOpT7e0QxfGS0TLD08A4M66K80ioaXiwMU1zUUv9IY

  String selectedPaymentMethod = 'Thanh toán khi nhận hàng';
  String selectedShippingMethod = 'Thường';
  String? selectedCode1;
  String? selectedCode2;
  String? selectedMoTa1;
  String? selectedMoTa2;
  String? giamCode1;
  String? giamCode2;

  final CheckoutController checkoutController = CheckoutController();
  bool isLoading = false;

  List<TTNhanHang> shippingAddresses = [];
  TTNhanHang? selectedAddress;
  final TTNhanHangController controller = TTNhanHangController();

  GiaoHangController giaoHangController = GiaoHangController();
  double? soKM = 0;
  String? origin;
  String? destination;
  static const String APIKEY = '8AOpT7e0QxfGS0TLD08A4M66K80ioaXiwMU1zUUv9IY';

  SanPhamController sanPhamController = SanPhamController();
  String? tenSP;

  MauSPController mauSPController = MauSPController();
  KichCoController kichCoController = KichCoController();

  @override
  void initState() {
    super.initState();
    _loadShippingAddresses();
    loadKMShip();
  }

  Future<String?> layTenMau(String maMau) async {
    try {
      return await mauSPController.layTenMauByMaMau(maMau);
    } catch (error) {
      return null;
    }
  }

  Future<String?> layTenKichCo(String maKichCo) async {
    try {
      return await kichCoController.layTenKichCo(maKichCo);
    } catch (error) {
      return null;
    }
  }

  Future<String?> getTenSP(String maSP) {
    return sanPhamController.getProductNameByMaSP(maSP);
  }

  Future<void> loadKMShip() async {
    try {
      TTNhanHangController ttNhanHangController = TTNhanHangController();
      TTNhanHang? ttNhanHang =
          await ttNhanHangController.fetchTTNhanHang('TT1');
      String? dcDau = ttNhanHang!.toaDo;

      String? dcDich = selectedAddress?.toaDo;

      if (dcDich != null && dcDau != null) {
        destination = dcDich.trim();
        origin = dcDau.trim();
        double? fetchedDistance =
            await giaoHangController.getDistance(origin!, destination!, APIKEY);

        setState(() {
          soKM = fetchedDistance;
        });
      }
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        soKM = 0;
      });
    }
  }

  Future<void> _loadShippingAddresses() async {
    try {
      final List<TTNhanHang> addresses =
          await controller.fetchTTNhanHangByCustomer(widget.customerId);
      setState(() {
        shippingAddresses = addresses;

        selectedAddress = addresses.isNotEmpty
            ? addresses.firstWhere(
                (address) => address.macDinh == true,
                orElse: () => addresses.first,
              )
            : null;
      });
    } catch (e) {
      print('Lỗi khi tải địa chỉ giao hàng: $e');
    }
  }

  double _tinhTongTien(double giaTien, int soLuong) {
    return giaTien * soLuong;
  }

  double tinhGiaShip(double phiCB, double soKMGiao) {
    return phiCB + (soKMGiao * 1000);
  }

  double getPhiCB() {
    if (selectedShippingMethod == 'Hỏa tốc') {
      return 50000;
    } else {
      String toaDo = selectedAddress?.toaDo ?? '';

      List<String> latLng = toaDo.split(',');
      if (latLng.length < 1) return 0;

      double lat;
      try {
        lat = double.parse(latLng[0]);
      } catch (e) {
        return 0;
      }

      if (lat >= 23) {
        // Miền Bắc
        return 29000;
      } else if (lat < 23 && lat >= 17) {
        // Miền Trung
        return 29000;
      } else if (lat < 17) {
        // Miền Nam
        return 27000;
      } else if (lat == 10.8231) {
        // Tọa độ TP.HCM
        return 25000;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Center(
                      child: Text(
                    'Thanh toán',
                    style: TextStyle(fontSize: 18),
                  ))),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        _buildSectionCard(
                          title: 'Thông tin nhận hàng',
                          content: selectedAddress != null
                              ? _buildAddressContent()
                              : const Text('Chưa có thông tin nhận hàng'),
                          onTap: () => _showShippingAddresses(context),
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Sản phẩm',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        _buildProductList(widget.dsSP, widget.slMua),
                        _buildSectionCard(
                          title: 'Phương thức vận chuyển',
                          content: Text(
                            selectedShippingMethod,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: _showShippingMethodOptions,
                        ),
                        _buildSectionCard(
                          title: 'Áp dụng khuyến mãi',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (selectedMoTa1 != null && selectedMoTa1!.isNotEmpty)
                                Text(
                                  selectedMoTa1!,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (selectedMoTa2 != null && selectedMoTa2!.isNotEmpty)
                                Text(
                                  selectedMoTa2!,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if ((selectedMoTa1 == null || selectedMoTa1!.isEmpty) &&
                                  (selectedMoTa2 == null || selectedMoTa2!.isEmpty))
                                const Text(
                                  'Chưa áp dụng mã giảm giá nào',
                                  style: TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                          onTap: _showPromoCodeOptions,
                        ),
                        _buildSectionCard(
                          title: 'Phương thức thanh toán',
                          content: Text(selectedPaymentMethod,
                            style: const TextStyle(fontSize: 12),),
                          onTap: _showPaymentMethodOptions,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildSummarySection(),
              ],
            ),
          );
  }

  Widget _buildProductList(List<ChiTietSP> dsSP, List<int> slMua) {
    SharedFunction sharedFunction = SharedFunction();
    StorageService storageService = StorageService();

    final List<ChiTietSP> products = dsSP;
    final List<int> sl = slMua;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return FutureBuilder<List<String?>>(
          future: Future.wait([
            getTenSP(product.maSP),
            layTenMau(product.maMau),
            layTenKichCo(product.maKichCo),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Text('Lỗi khi tải thông tin sản phẩm');
            } else {
              final productName = snapshot.data![0] ?? 'Tên sản phẩm không có';
              final tenMau = snapshot.data![1]; // Tên màu
              final tenKC = snapshot.data![2]; // Tên kích cỡ

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.network(
                      storageService.getImageUrl(product.maHinhAnh),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productName,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          if (tenMau != null) Text(tenMau, style: const TextStyle(fontSize: 12),),
                          if (tenKC != null) Text(tenKC, style: const TextStyle(fontSize: 12),),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text(sharedFunction.formatCurrency(product.giaBan),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.red)),
                        Text('x${sl[index]}', style: const TextStyle(fontSize: 13),)
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget content,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFf8f8ff),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                  const SizedBox(height: 6),
                  content,
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${selectedAddress!.hoTen} | ${selectedAddress!.sdt}', style: const TextStyle(fontSize: 12),),
        const SizedBox(height: 4),
        Text(selectedAddress!.diaChi, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,),
      ],
    );
  }

  void _showPaymentMethodOptions() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodPage(
          selectedMethod: selectedPaymentMethod,
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        selectedPaymentMethod = selected;
      });
    }
  }

  void _showShippingMethodOptions() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingMethodPage(
          selectedMethod: selectedShippingMethod,
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        selectedShippingMethod = selected;
      });
    }
  }

  void _showPromoCodeOptions() async {
    double subtotal = 0;
    for (int i = 0; i < widget.dsSP.length; i++) {
      subtotal += _tinhTongTien(widget.dsSP[i].giaBan, widget.slMua[i]);
    }

    final selected = await Navigator.push<List<String?>>(
      context,
      MaterialPageRoute(
        builder: (context) => PromoCodePage(
          selectedCodeType1: selectedCode1,
          selectedCodeType2: selectedCode2,
          maKH: widget.customerId,
          value1: giamCode1,
          value2: giamCode2,
          selectedName1: selectedMoTa1,
          selectedName2: selectedMoTa2,
          total: subtotal,
        ),
      ),
    );

    if (selected != null && selected.isNotEmpty) {
      if (selected.length == 6) {
        setState(() {
          selectedCode1 = selected[0];
          selectedCode2 = selected[1];
          selectedMoTa1 = selected[2];
          selectedMoTa2 = selected[3];
          giamCode1 = selected[4];
          giamCode2 = selected[5];
        });
      }
    }
  }

  Widget _buildSummarySection() {
    double subtotal = 0;
    for (int i = 0; i < widget.dsSP.length; i++) {
      subtotal += _tinhTongTien(widget.dsSP[i].giaBan, widget.slMua[i]);
    }

    double giaShip = tinhGiaShip(getPhiCB(), soKM ?? 0);
    double giaGiam1 = double.parse(giamCode1 ?? '0');
    double giaGiam2 = double.parse(giamCode2 ?? '0');
    double tongTien = 0;

    if (giaGiam2 > giaShip) {
      tongTien = subtotal - giaGiam1;
    } else {
      tongTien = subtotal + giaShip - giaGiam1 - giaGiam2;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Tạm tính', subtotal, giaGiam: giaGiam1),
          _buildSummaryRow('Phí giao hàng', giaShip, giaGiam: giaGiam2),
          _buildSummaryRow('Tổng cộng', tongTien, isTotal: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              String maDH;
              maDH = await checkoutController.checkOut(
                selectedAddress?.maTTNH ?? shippingAddresses.first.maTTNH,
                widget.customerId,
                selectedShippingMethod,
                selectedPaymentMethod,
                tongTien,
                false,
              );

              ChiTietGioHangController ctGHController =
                  ChiTietGioHangController();
              KMDHController kmdhController = KMDHController();

              for (int i = 0; i < widget.dsSP.length; i++) {
                await checkoutController.addChiTietDonHang(new ChiTietDonHang(
                    donHang: maDH,
                    sanPham: widget.dsSP[i].maCTSP,
                    soLuong: widget.slMua[i],
                    donGia: widget.dsSP[i].giaBan));

                if (widget.muaTu == "Giỏ hàng") {
                  await ctGHController.xoaChiTietGioHang(
                      widget.maGH, widget.dsSP[i].maCTSP);
                }
              }

              if (selectedCode1 != null && selectedCode2 != null) {
                await kmdhController.createKMDH(
                    new KMDH(donHang: maDH, khuyenMai: selectedCode1 ?? ''));
                await kmdhController.createKMDH(
                    new KMDH(donHang: maDH, khuyenMai: selectedCode2 ?? ''));
              }

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => SuccessPage(
                          maKH: widget.customerId,
                        )),
                (route) => route.isFirst,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text(
              'Đặt hàng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount,
      {double giaGiam = 0, bool isTotal = false}) {
    double finalAmount = amount - giaGiam;

    if (finalAmount < 0) {
      finalAmount = 0;
    }

    SharedFunction sharedFunction = SharedFunction();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 125,
              child: Text(label, style: const TextStyle(fontSize: 15))),
          if (giaGiam > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 85,
                  child: Text(
                    sharedFunction.formatCurrency(amount),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isTotal ? FontWeight.bold : FontWeight.normal,
                        fontFamily: 'Gabarito',
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(
                  ' - ${sharedFunction.formatCurrency(giaGiam)}',
                  style: const TextStyle(
                      fontSize: 13, color: Colors.red, fontFamily: 'Gabarito'),
                ),
              ],
            ),
          SizedBox(
            width: 90,
            child: Text(
              sharedFunction.formatCurrency(finalAmount),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Gabarito'),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showShippingAddresses(BuildContext context) async {
    final selected = await Navigator.push<TTNhanHang?>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectAddressPage(
          shippingAddresses: shippingAddresses,
          selectedAddress: selectedAddress ?? shippingAddresses.first,
          maKH: widget.customerId,
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        selectedAddress = selected;
        loadKMShip();
      });
    }
  }
}
