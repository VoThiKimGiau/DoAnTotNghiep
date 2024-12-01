import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:datn_cntt304_bandogiadung/models/MauSP.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../controllers/MauSPController.dart';

class AdminSuaMauSP extends StatefulWidget {
  final String maMau;

  AdminSuaMauSP({required this.maMau});

  @override
  _AdminSuaMauSPState createState() => _AdminSuaMauSPState();
}

class _AdminSuaMauSPState extends State<AdminSuaMauSP> {
  MauSPController mauSPController = MauSPController();
  MauSP? itemMauSP;
  bool isLoading = true;
  final TextEditingController tenMauController = TextEditingController();
  Color selectedColor = Colors.blue; // Default color

  @override
  void initState() {
    super.initState();
    fetchMauSP();
  }

  Future<void> fetchMauSP() async {
    try {
      MauSP? fetchItem = await mauSPController.layMauTheoMa(widget.maMau);
      if (fetchItem != null) {
        setState(() {
          itemMauSP = fetchItem;
          tenMauController.text = fetchItem.tenMau;
          selectedColor = Color(int.parse(fetchItem.maHEX.replaceFirst('#', '0xff')));
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching MauSP: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải màu sản phẩm. Vui lòng thử lại.')),
      );
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    if (itemMauSP != null) {
      try {
        MauSP updatedMauSP = MauSP(
          maMau: itemMauSP!.maMau,
          tenMau: tenMauController.text,
          maHEX: '#${selectedColor.value.toRadixString(16).substring(2, 8)}', // Convert Color to HEX
        );

        await mauSPController.updateMauSP(updatedMauSP.maMau, updatedMauSP);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật màu sản phẩm thành công')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        print('Error saving changes: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi cập nhật. Vui lòng kiểm tra lại')),
        );
      }
    }
  }

  void openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn màu'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color; // Update selected color
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Chọn'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  // Update the HEX code in the text field
                  // This will automatically update the HEX value used during save
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.white,
                        ),
                        child: SvgPicture.asset('assets/icons/arrowleft.svg'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Text(
                        'SỬA MÀU SẢN PHẨM',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  children: [
                    TextField(
                      controller: tenMauController,
                      decoration: const InputDecoration(
                        labelText: 'Tên màu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Mã HEX',
                        hintText: selectedColor.value.toRadixString(16).substring(2, 8), // Show HEX code
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.color_lens),
                          onPressed: openColorPicker, // Open color picker
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Save button
                    ElevatedButton(
                      onPressed: () {
                        saveChanges(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                        'Lưu',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}