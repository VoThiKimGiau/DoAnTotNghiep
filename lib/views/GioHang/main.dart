import 'package:flutter/material.dart';
import '../../models/ChiTietGioHang.dart';
import 'GioHangPage.dart';
List<ChiTietGioHang> cartItems = []; // Danh sách giỏ hàng
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductSelectionPage(),
    );
  }
}
class ProductSelectionPage extends StatefulWidget {
  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}
class _ProductSelectionPageState extends State<ProductSelectionPage> {
  String color = "Orange";
  String size = "Nhỏ";
  int quantity = 1; // Giá trị mặc định của số lượng là 1
  final Map<String, double> sizePrices = {
    'Nhỏ': 148.00,
    'Vừa': 168.00,
    'Lớn': 188.00,
  };
  double get currentPrice => sizePrices[size]!;
  void _showOrderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Chọn màu sắc
                  Text("Màu sắc:", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['Orange', 'Black', 'Red'].map((String value) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            color = value;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: value == color ? Colors.blue : Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                value,
                                style: TextStyle(color: value == color ? Colors.white : Colors.black),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(value, style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  // Chọn kích cỡ
                  Text("Kích cỡ:", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: sizePrices.keys.map((String value) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            size = value;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: value == size ? Colors.blue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(value, style: TextStyle(color: value == size ? Colors.white : Colors.black)),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  // Hiển thị giá sản phẩm
                  Text(
                    "Giá: \$${(currentPrice * quantity).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Số lượng
                  Text("Số lượng:", style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setModalState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(quantity.toString(), style: TextStyle(fontSize: 24)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setModalState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Thêm vào giỏ hàng
                  ElevatedButton(
                    onPressed: () {
                      cartItems.add(ChiTietGioHang(
                        maGioHang: 'GH${cartItems.length + 1}', // Tạo mã giỏ hàng
                        maSP: 'Sản phẩm 1', // Có thể thay đổi thành mã sản phẩm thực tế
                        maKichCo: size,
                        maMau: color,
                        soLuong: quantity,
                        donGia: currentPrice,
                      ));
                      // Đặt lại số lượng về mặc định
                      setModalState(() {
                        quantity = 1; // Đặt lại số lượng về 1
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã thêm vào giỏ hàng!')),
                      );
                    },
                    child: Text("Thêm vào giỏ hàng"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GioHangPage(gioHangItems: cartItems)),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showOrderSheet(context),
          child: Text('Chọn sản phẩm'),
        ),
      ),
    );
  }
}