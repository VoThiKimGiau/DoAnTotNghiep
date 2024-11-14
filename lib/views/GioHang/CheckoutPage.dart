import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/CheckoutController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/GiaoHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/KMKH.dart';
import 'package:datn_cntt304_bandogiadung/models/Promotion.dart';
import 'package:flutter/material.dart';
import 'PaymentMethodPage.dart';
import 'PromoCodePage.dart';
import 'SelectAddressPage.dart';
import 'ShippingMethodPage.dart';
import 'SuccessPage.dart';
import '../../controllers/TTNhanHangController.dart';
import '../../models/TTNhanHang.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount;
  final String? customerId; // Thêm tham số cho mã khách hàng

  const CheckoutPage({
    super.key,
    required this.totalAmount,
    required this.customerId,
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
  String selectedPromoCode = '';
  List<Promotion> promoCodes = [];
  final CheckoutController checkoutController = CheckoutController();

  List<TTNhanHang> shippingAddresses = [];
  TTNhanHang? selectedAddress;
  final TTNhanHangController controller =
      TTNhanHangController(); // Khởi tạo controller

  GiaoHangController giaoHangController = GiaoHangController();
  double? soKM = 0;
  String? origin;
  String? destination;
  static const String APIKEY = '8AOpT7e0QxfGS0TLD08A4M66K80ioaXiwMU1zUUv9IY';

  @override
  void initState() {
    super.initState();
    _loadShippingAddresses(); // Tải địa chỉ giao hàng
    _loadPromotion();
    loadKMShip();
  }

  _loadPromotion() async {
    List<KMKH> kmkhs = await checkoutController.fetchKMKH(widget.customerId!);
    kmkhs.forEach((element) async {
      final promo = await checkoutController.fetchDetailKM(element.khuyenMai);
      setState(() {
        promoCodes.add(promo);
      });
    });
  }

  Future<void> loadKMShip() async {
    try {
      String dcDau = '140 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP.HCM, Việt Nam';
      String? dcDich = 'Phường 5, Quận Gò Vấp, TP.HCM, Việt Nam';
      //String? dcDich = selectedAddress!.diaChi;

      if (dcDich != null && dcDau != null) {
        destination = dcDich;
        origin = dcDau;
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
          await controller.fetchTTNhanHangByCustomer(
              widget.customerId); // Sử dụng mã khách hàng
      setState(() {
        shippingAddresses = addresses;
        if (shippingAddresses.isNotEmpty) {
          selectedAddress =
              shippingAddresses.first; // Chọn địa chỉ đầu tiên làm mặc định
        }
      });
    } catch (e) {
      print('Lỗi khi tải địa chỉ giao hàng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: 'Thông tin nhận hàng',
                    content: selectedAddress != null
                        ? _buildAddressContent()
                        : Text('Chưa có thông tin nhận hàng'),
                    onTap: () => _showShippingAddresses(context),
                  ),
                  _buildSectionCard(
                    title: 'Phương thức thanh toán',
                    content: Text(selectedPaymentMethod),
                    onTap: _showPaymentMethodOptions,
                  ),
                  _buildSectionCard(
                    title: 'Phương thức vận chuyển',
                    content: Text(selectedShippingMethod),
                    onTap: _showShippingMethodOptions,
                  ),
                  _buildSectionCard(
                    title: 'Áp dụng khuyến mãi',
                    content: Text(selectedPromoCode.isNotEmpty
                        ? selectedPromoCode
                        : 'Không có mã giảm giá'),
                    onTap: _showPromoCodeOptions,
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
          color: Colors.grey[200],
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
        Text('${selectedAddress!.hoTen} | ${selectedAddress!.sdt}'),
        const SizedBox(height: 4),
        Text(selectedAddress!.diaChi),
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
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => PromoCodePage(
          selectedPromoCode: selectedPromoCode,
          promotions: promoCodes,
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        selectedPromoCode = selected;
      });
    }
  }

  Widget _buildSummarySection() {
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
          _buildSummaryRow('Tạm tính', widget.totalAmount),
          _buildSummaryRow('Phí giao hàng', soKM!),
          _buildSummaryRow('Tổng cộng', widget.totalAmount, isTotal: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await checkoutController.checkOut(
                "TT1",
                widget.customerId,
                "Hỏa tốc",
                "Thanh toan sau khi nhan hang",
                0,
                true,
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SuccessPage(maKH: widget.customerId,)),
                (route) => route.isFirst,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Đặt hàng',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
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
      });
    }
  }
}
