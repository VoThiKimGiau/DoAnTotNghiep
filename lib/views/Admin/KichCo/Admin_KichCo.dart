import 'package:datn_cntt304_bandogiadung/views/Admin/KichCo/Admin_SuaKC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors/color.dart';
import '../../../controllers/KichCoController.dart';
import '../../../models/KichCo.dart';


class AdminKichCoScreen extends StatefulWidget {
  @override
  _AdminKichCoScreen createState() => _AdminKichCoScreen();
}

class _AdminKichCoScreen extends State<AdminKichCoScreen> {
  KichCoController kichCoController = KichCoController();
  List<KichCo>? kichCos;

  @override
  void initState() {
    super.initState();
    fetchKichCos();
  }

  Future<void> fetchKichCos() async {
    try {
      List<KichCo> fetchedKichCos = await kichCoController.fetchAllKichCo();
      setState(() {
        kichCos = fetchedKichCos;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        kichCos = [];
      });
    }
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

  void _addKichCo() {
    String newKichCo = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm kích cỡ mới'),
          content: TextField(
            onChanged: (value) {
              newKichCo = value;
            },
            decoration: const InputDecoration(labelText: 'Nhập tên kích cỡ'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                if (newKichCo.isNotEmpty) {
                  // Thêm kích cỡ mới vào cơ sở dữ liệu
                  int newKC = kichCos?.length ?? 0;
                  await kichCoController.addKichCo(new KichCo(
                      tenKichCo: newKichCo, maKichCo: 'KC${newKC + 1}'));

                  // Cập nhật danh sách kích cỡ
                  fetchKichCos();

                  // Đóng dialog
                  Navigator.of(context).pop();
                  _showErrorDialog('Thêm kích cỡ thành công!', 'Thông báo');
                } else {
                  _showErrorDialog('Tên kích cỡ không được để trống!', 'Lỗi');
                }
              },
              child: const Text('Xác Nhận'),
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
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 24, top: 30, bottom: 15),
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
                    delegate: CustomKichCoSearch(),
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
                    'Kích cỡ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _addKichCo();
                        },
                        child: const Text(
                          'Thêm kích cỡ',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Gabarito',
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
                child: kichCos == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: kichCos!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(kichCos![index].tenKichCo),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminSuaKC(
                              maKichCo: kichCos![index].maKichCo,
                            ),
                          ),
                        );

                        if (result) {
                          fetchKichCos();
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

class CustomKichCoSearch extends SearchDelegate {
  final KichCoController kichCoController = KichCoController();

  Future<List<KichCo>> fetchKichCos() async {
    try {
      return await kichCoController.fetchAllKichCo();
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
    return FutureBuilder<List<KichCo>>(
      future: fetchKichCos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có kích cỡ trùng khớp!'));
        }

        final results = snapshot.data!
            .where((item) => item.tenKichCo.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final kichCo = results[index];
              return ListTile(
                title: Text(kichCo.tenKichCo),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminSuaKC(
                        maKichCo: kichCo.maKichCo,
                      ),
                    ),
                  );

                  if (result) {
                    fetchKichCos();
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
    return FutureBuilder<List<KichCo>>(
      future: fetchKichCos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có kích cỡ trùng khớp!'));
        }

        final suggestions = snapshot.data!
            .where((item) => item.tenKichCo.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final item = suggestions[index];
              return ListTile(
                title: Text(item.tenKichCo),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminSuaKC(
                        maKichCo: item.maKichCo,
                      ),
                    ),
                  );

                  if (result) {
                    fetchKichCos();
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