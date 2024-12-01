import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors/color.dart';
import '../../../controllers/MauSPController.dart';
import '../../../models/MauSP.dart';
import 'Admin_SuaMauSP.dart';

class AdminMauSPScreen extends StatefulWidget {
  @override
  _AdminMauSPScreen createState() => _AdminMauSPScreen();
}

class _AdminMauSPScreen extends State<AdminMauSPScreen> {
  MauSPController mauSPController = MauSPController();
  List<MauSP>? mauSPs;

  @override
  void initState() {
    super.initState();
    fetchMauSPs();
  }

  void _showErrorDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _addMau() {
    String newTenMau = '';
    Color newColor = Colors.blue; // Màu mặc định

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm Màu Mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    newTenMau = value; // Lưu tên màu mới
                  },
                  decoration: const InputDecoration(labelText: 'Tên màu'),
                ),
                const SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Mã HEX',
                    hintText:
                    '#${newColor.value.toRadixString(16).substring(2, 8)}',
                    // Hiển thị mã HEX
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.color_lens),
                      onPressed: () {
                        // Mở ColorPicker
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Chọn màu'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: newColor,
                                  onColorChanged: (Color color) {
                                    setState(() {
                                      newColor = color; // Cập nhật màu đã chọn
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
                                    Navigator.of(context)
                                        .pop(); // Đóng dialog ColorPicker
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: const Text('Xác Nhận'),
              onPressed: () async {
                if (newTenMau.isNotEmpty) {
                  int idMau = mauSPs?.length ?? 0;
                  MauSP newMauSP = MauSP(
                    maMau: 'MM${idMau + 1}',
                    tenMau: newTenMau,
                    maHEX:
                    '#${newColor.value.toRadixString(16).substring(2, 8)}',
                  );

                  await mauSPController.addMauSP(newMauSP);

                  await fetchMauSPs();

                  Navigator.of(context).pop();
                  _showErrorDialog('Thêm màu thành công!', 'Thông báo');
                } else {
                  _showErrorDialog('Vui lòng điền đầy đủ thông tin!', 'Lỗi');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchMauSPs() async {
    try {
      List<MauSP> fetchedMauSPs = await mauSPController.fetchAllMauSP();
      setState(() {
        mauSPs = fetchedMauSPs;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        mauSPs = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 15, top: 30, bottom: 15),
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
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomMauSPSearch(),
                  );
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF4F4F4),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      prefixIcon: Image.asset('assets/icons/search.png'),
                      hintText: 'Tìm kiếm theo tên',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Màu sản phẩm',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _addMau();
                        },
                        child: const Text(
                          'Thêm màu sản phẩm',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: mauSPs == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: mauSPs!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(mauSPs![index].maHEX.replaceFirst('#', '0xFF'))),
                          border: Border.all(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                      ),
                      title: Text(
                        mauSPs![index].tenMau,
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminSuaMauSP(
                              maMau: mauSPs![index].maMau,
                            ),
                          ),
                        );

                        if (result) {
                          fetchMauSPs();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomMauSPSearch extends SearchDelegate {
  final MauSPController mauSPController = MauSPController();

  Future<List<MauSP>> fetchMauSPs() async {
    try {
      return await mauSPController.fetchAllMauSP();
    } catch (e) {
      return [];
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: SvgPicture.asset('assets/icons/arrowleft.svg'),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<MauSP>>(
      future: fetchMauSPs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có màu trùng khớp!'));
        }

        final results = snapshot.data!
            .where((item) =>
            item.tenMau.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final mauSP = results[index];
              return ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(int.parse(mauSP.maHEX.replaceFirst('#', '0xFF'))),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                ),
                title: Text(mauSP.tenMau),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminSuaMauSP(
                        maMau: mauSP.maMau,
                      ),
                    ),
                  );

                  if (result) {
                    fetchMauSPs();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<MauSP>>(
      future: fetchMauSPs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có màu trùng khớp!'));
        }

        final suggestions = snapshot.data!
            .where((item) =>
            item.tenMau.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final item = suggestions[index];
              return ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(int.parse(item.maHEX.replaceFirst('#', '0xFF'))),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                ),
                title: Text(item.tenMau),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminSuaMauSP(
                        maMau: item.maMau,
                      ),
                    ),
                  );

                  if (result) {
                    fetchMauSPs();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}