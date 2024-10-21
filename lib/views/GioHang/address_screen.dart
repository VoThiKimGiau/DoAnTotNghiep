import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // Biến trạng thái cho địa chỉ được chọn
  String selectedAddress = 'Hoàng Minh | (+84) 3344556677\n140 Lê Trọng Tấn\nPhường Tây Thạnh,Quận Tân Phú\nTP.HCM';

  // Hàm xử lý khi chọn một địa chỉ
  void _onAddressSelected(String address) {
    setState(() {
      selectedAddress = address;
    });
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
        title: Text('Chọn địa chỉ nhận hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Danh sách địa chỉ
            Expanded(
              child: ListView(
                children: [
                  _buildAddressItem(
                    address: 'Hoàng Minh | (+84) 3344556677\n140 Lê Trọng Tấn\nPhường Tây Thạnh,Quận Tân Phú\nTP.HCM',
                    isCurrent: true,
                  ),
                  SizedBox(height: 8.0),
                  _buildAddressItem(
                    address: 'Hai Ho | (+84) 3344556688\n140 Lê Trọng Tấn\nPhường Tây Thạnh,Quận Tân Phú\nTP.HCM',
                  ),
                  SizedBox(height: 8.0),
                  _buildAddressItem(
                    address: 'Kim Giou | (+84) 2344556688\n140 Lê Trọng Tấn\nPhường Tây Thạnh,Quận Tân Phú\nTP.HCM',
                  ),
                ],
              ),
            ),

            // Nút Thêm địa chỉ mới
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Logic thêm địa chỉ mới
                // Ví dụ: Hiển thị một modal dialog để nhập thông tin địa chỉ mới
                // Sau đó thêm địa chỉ mới vào list địa chỉ
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
              child: Text('Thêm mới địa chỉ'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic xử lý khi nhấn FloatingActionButton
          // Ví dụ: Hiển thị một modal dialog để nhập thông tin địa chỉ mới
          // Sau đó thêm địa chỉ mới vào list địa chỉ
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Hàm tạo widget hiển thị một mục địa chỉ
  Widget _buildAddressItem({
    required String address,
    bool isCurrent = false,
  }) {
    return GestureDetector(
      onTap: () {
        _onAddressSelected(address); // Gọi hàm xử lý khi chọn địa chỉ
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddressScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isCurrent ? Colors.blue : Colors.grey[300]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 4.0),
                if (isCurrent)
                  Text(
                    'Mặc định',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600]!,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Logic xử lý khi nhấn nút Sửa
                    // Ví dụ: Hiển thị một modal dialog để sửa thông tin địa chỉ
                  },
                  tooltip: 'Sửa',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}