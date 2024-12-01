import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../controllers/NhaCungCapController.dart';
import '../../../models/NhaCungCap.dart';
import 'Admin_SuaNCC.dart';

class AdminSupplierListScreen extends StatefulWidget {
  @override
  _AdminSupplierListScreen createState() => _AdminSupplierListScreen();
}

class _AdminSupplierListScreen extends State<AdminSupplierListScreen> {
  NCCController nccController = NCCController();
  List<NhaCungCap>? suppliers;

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    try {
      List<NhaCungCap> fetchedSuppliers = await nccController.fetchSuppliers();
      setState(() {
        suppliers = fetchedSuppliers;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        suppliers = [];
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
                    delegate: CustomSupplierSearch(),
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
                      hintText: 'Tìm kiếm',
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
                    'Nhà cung cấp',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to add supplier screen
                        },
                        child: const Text(
                          'Thêm nhà cung cấp',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
                child: suppliers == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: suppliers!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suppliers![index].tenNCC),
                      subtitle: Text(suppliers![index].sdt),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminSuaNCC(
                              maNCC: suppliers![index].maNCC,
                            ),
                          ),
                        );

                        if (result) {
                          fetchSuppliers();
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

class CustomSupplierSearch extends SearchDelegate {
  final NCCController nccController = NCCController();

  Future<List<NhaCungCap>> fetchSuppliers() async {
    try {
      return await nccController.fetchSuppliers();
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
    return FutureBuilder<List<NhaCungCap>>(
      future: fetchSuppliers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có nhà cung cấp trùng khớp!'));
        }

        final results = snapshot.data!
            .where((item) => item.tenNCC.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final supplier = results[index];
            return ListTile(
              title: Text(supplier.tenNCC),
              subtitle: Text(supplier.sdt),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSuaNCC(
                      maNCC: supplier.maNCC,
                    ),
                  ),
                );

                if (result) {
                  fetchSuppliers();
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<NhaCungCap>>(
      future: fetchSuppliers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có nhà cung cấp trùng khớp!'));
        }

        final suggestions = snapshot.data!
            .where((item) => item.tenNCC.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final item = suggestions[index];
            return ListTile(
              title: Text(item.tenNCC),
              subtitle: Text(item.sdt),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSuaNCC(
                      maNCC: item.maNCC,
                    ),
                  ),
                );

                if (result) {
                  fetchSuppliers();
                }
              },
            );
          },
        );
      },
    );
  }
}