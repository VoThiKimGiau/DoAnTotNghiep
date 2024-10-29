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

  CheckoutPage({required this.totalAmount, required this.customerId}); // Cập nhật constructor

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = 'Thanh toán khi nhận hàng';
  String selectedShippingMethod = 'Thường';
  String selectedPromoCode = '';
  List<String> promoCodes = [
    'Giảm tối đa \$30',
    'Giảm 9%',
    'Giảm tối đa \$70',
  ];

  List<TTNhanHang> shippingAddresses = [];
  TTNhanHang? selectedAddress;
  final TTNhanHangController controller = TTNhanHangController(); // Khởi tạo controller

  @override
  void initState() {
    super.initState();
    _loadShippingAddresses(); // Tải địa chỉ giao hàng
  }

  Future<void> _loadShippingAddresses() async {
    try {
      final List<TTNhanHang> addresses = await controller.fetchTTNhanHangByCustomer(widget.customerId); // Sử dụng mã khách hàng
      setState(() {
        shippingAddresses = addresses;
        if (shippingAddresses.isNotEmpty) {
          selectedAddress = shippingAddresses.first; // Chọn địa chỉ đầu tiên làm mặc định
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  content,
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
          promoCodes: promoCodes,
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
      decoration: BoxDecoration(
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
          _buildSummaryRow('Phí giao hàng', 8.0),
          _buildSummaryRow('Tổng cộng', widget.totalAmount + 8.0, isTotal: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Logic để xử lý đặt hàng
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SuccessPage()),
              );
            },
            child: Text('Đặt hàng'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
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
          selectedAddress: selectedAddress ?? shippingAddresses.first, maKH: widget.customerId,
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
