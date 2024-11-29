import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/views/NhapHang/LowQuantityScreen.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import '../../widgets/ActionButton.dart';
import '../../widgets/InfoCard.dart';
import '../../widgets/StatCard.dart';
import 'DanhSachPhieuNhap.dart';


class WarehouseInfoScreen extends StatefulWidget {
  final String maNV;

  WarehouseInfoScreen({Key? key, required this.maNV}) : super(key: key);
  @override
  _WarehouseInfoScreenState createState() => _WarehouseInfoScreenState();
}

class _WarehouseInfoScreenState extends State<WarehouseInfoScreen> {
  final ChiTietSPController chiTietSPController = ChiTietSPController();
  final SharedFunction sharedFunction = SharedFunction();

  // Variables to store API data
  int stockQuantity = 0;
  double stockValue = 0.0;
  double estimatedSaleValue = 0.0;
  double expectedProfit = 0.0;
  int lowInventoryCount = 0;
  int availableItemsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchWarehouseData();
  }

  Future<void> _fetchWarehouseData() async {
    try {
      final stockQuantityResult = await chiTietSPController.getTotalSlKho();
      final stockValueResult = await chiTietSPController.getTotalInventoryValue();
      final estimatedSaleValueResult = await chiTietSPController.getTotalSoldValue();
      // final lowInventoryCountResult = await chiTietSPController.getItemsWithLowInventory(10);
      final availableItemsCountResult = await chiTietSPController.getAvailableItems();

      setState(() {
        stockQuantity = stockQuantityResult;
        stockValue = stockValueResult;
        estimatedSaleValue = estimatedSaleValueResult;
        expectedProfit = stockValue -estimatedSaleValue;
        // lowInventoryCount = lowInventoryCountResult;
        availableItemsCount = availableItemsCountResult;
      });
    } catch (e) {
      print('Failed to fetch warehouse data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {

                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Thông tin kho',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,

                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.5,
                      children: [
                        StatCard(
                          title: "Giá trị tồn",
                          value: "${sharedFunction.formatCurrency(stockValue)} ",
                          valueColor: Colors.red,
                        ),
                        StatCard(
                          title: "Số lượng tồn",
                          value: "$stockQuantity",
                          valueColor: Colors.red,
                        ),
                        StatCard(
                          title: "Giá trị bán ước tính",
                          value: "${sharedFunction.formatCurrency(estimatedSaleValue)}",
                        ),
                        StatCard(
                          title: "Lợi nhuận kỳ vọng",
                          value: "${sharedFunction.formatCurrency(expectedProfit)} ",
                          valueColor: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          ActionButton(text: "Lịch sử kho"),
                          ActionButton(text: "Phiếu kho"),
                          ActionButton(text: "Kiểm kho"),
                          ActionButton(text: "Trả hàng nhập"),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                             Navigator.push(context,
                             MaterialPageRoute( builder: (context) => LowQuantityScreen())
                             );
                            },
                            child: InfoCard(
                              icon: Icons.label,
                              title: "Dưới định mức tồn",
                              value: "",
                              iconColor: Colors.yellow,
                            ),
                          ),
                          SizedBox(width: 8),

                        ],
                      ),
                    )
                    ,
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => PurchaseOrderList(maNV: widget.maNV))

                                );
                              },
                              child: Text("↑ Nhập hàng"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
