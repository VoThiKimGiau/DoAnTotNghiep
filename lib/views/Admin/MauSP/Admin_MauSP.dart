import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                    'Màu sản phẩm',
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
                          // Navigate to add MauSP screen
                        },
                        child: const Text(
                          'Thêm màu sản phẩm',
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
                child: mauSPs == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: mauSPs!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(mauSPs![index].tenMau),
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
            .where((item) => item.tenMau.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final mauSP = results[index];
            return ListTile(
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
            .where((item) => item.tenMau.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final item = suggestions[index];
            return ListTile(
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
        );
      },
    );
  }
}