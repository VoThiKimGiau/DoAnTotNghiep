import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/cart_screen.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/size_option.dart';
import 'package:datn_cntt304_bandogiadung/views/GioHang/color_option.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Comfortaa',
      ),
      home: SafeArea(
          child: Scaffold(
            body: ProductDetails(),
          )
      ),
    );
  }
}

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // Biến trạng thái cho màu sắc, kích cỡ và số lượng
  String selectedColor = 'Cam';
  String selectedSize = 'Nhỏ';
  int quantity = 1;

  // Hàm xử lý lựa chọn màu sắc
  void _onColorSelected(String color) {
    setState(() {
      selectedColor = color;
    });
  }

  // Hàm xử lý lựa chọn kích cỡ
  void _onSizeSelected(String size) {
    setState(() {
      selectedSize = size;
    });
  }

  // Hàm xử lý thay đổi số lượng
  void _onQuantityChanged(int value) {
    setState(() {
      quantity = value;
    });
  }

  // Hàm hiển thị bảng lựa chọn
  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lựa chọn màu sắc
              Text(
                'Màu sắc',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 10.0),
              Wrap(
                spacing: 16.0,
                children: [
                  ColorOption(
                    color: Colors.orange,
                    isSelected: selectedColor == 'Cam',
                    onTap: () => _onColorSelected('Cam'),
                  ),
                  ColorOption(
                    color: Colors.black,
                    isSelected: selectedColor == 'Đen',
                    onTap: () => _onColorSelected('Đen'),
                  ),
                  ColorOption(
                    color: Colors.red,
                    isSelected: selectedColor == 'Đỏ',
                    onTap: () => _onColorSelected('Đỏ'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              // Lựa chọn kích cỡ
              Text(
                'Kích cỡ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 10.0),
              Wrap(
                spacing: 16.0,
                children: [
                  SizeOption(
                    size: 'Nhỏ',
                    isSelected: selectedSize == 'Nhỏ',
                    onTap: () => _onSizeSelected('Nhỏ'),
                  ),
                  SizeOption(
                    size: 'Vừa',
                    isSelected: selectedSize == 'Vừa',
                    onTap: () => _onSizeSelected('Vừa'),
                  ),
                  SizeOption(
                    size: 'Lớn',
                    isSelected: selectedSize == 'Lớn',
                    onTap: () => _onSizeSelected('Lớn'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              // Lựa chọn số lượng
              Text(
                'Số lượng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) {
                        _onQuantityChanged(quantity - 1);
                      }
                    },
                  ),
                  Text(
                    '$quantity',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _onQuantityChanged(quantity + 1);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              // Nút Đặt hàng
              ElevatedButton(
                onPressed: () {
                  // Thêm sản phẩm vào giỏ hàng
                  // ... (logic thêm sản phẩm)
                  // Chuyển đến trang giỏ hàng
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(), // Chuyển đến CartScreen
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Đặt hàng'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            Image.asset(''),

            // Tiêu đề sản phẩm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sản phẩm 1',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Giá sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '\$148',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Mô tả sản phẩm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Được thiết kế cho cuộc sống và bền bỉ theo thời gian, chiếc áo khoác nỉ có khóa kéo này là một phần của bộ sưu tập Nike Life của chúng tôi. Form áo rộng rãi cho phép bạn mặc nhiều lớp bên trong, trong khi chất liệu nỉ mềm mại mang đến phong cách giản dị và bất hủ.',
              ),
            ),

            // Sản phẩm tương tự
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sản phẩm tương tự',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Lưới sản phẩm tương tự
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(''),
                      SizedBox(height: 8.0),
                      Text(
                        'Dao SP${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        '\$150.99',
                        style: TextStyle(
                          color: Colors.grey[600]!,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Nút Thêm vào giỏ hàng
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _showOptionsBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Thêm vào giỏ hàng'),
              ),
            ),

            // Nút Đặt hàng
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _showOptionsBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                child: Text('Đặt hàng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Lựa chọn Màu sắc
class ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: isSelected
              ? Border.all(
            color: Colors.blue,
            width: 2.0,
          )
              : null,
        ),
      ),
    );
  }
}

// Widget Lựa chọn Kích cỡ
class SizeOption extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onTap;

  const SizeOption({
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          size,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}