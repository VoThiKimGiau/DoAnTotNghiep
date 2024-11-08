import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/models/KichCo.dart';
import 'package:flutter/material.dart';

class CircleButtonSize extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelected;

  CircleButtonSize({
    required this.items,
    required this.onSelected,
  });

  @override
  _CircleButtonSize createState() => _CircleButtonSize();
}

class _CircleButtonSize extends State<CircleButtonSize> {
  int selectedIndex = -1; // Không có nút nào được chọn

  KichCoController kichCoController = KichCoController();
  List<KichCo> dsKichCo = [];
  bool isLoading = false;

  void onSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelected(dsKichCo[index].maKichCo);
  }

  @override
  void initState() {
    super.initState();
    fetchKichCo();
  }

  Future<void> fetchKichCo() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<KichCo> fetchedItems = [];

      for (String item in widget.items) {
        KichCo itemKichCo = await kichCoController.layKichCo(item);
        fetchedItems.add(itemKichCo);
      }

      setState(() {
        dsKichCo = fetchedItems;
        if (dsKichCo.isNotEmpty) {
          selectedIndex = 0; // Set default selection to the first item
          widget.onSelected(dsKichCo[0]
              .maKichCo); // Notify the parent of the default selection
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        dsKichCo = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onSelected(index),
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: selectedIndex == index
                                ? AppColors.primaryColor
                                : Colors.grey,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dsKichCo[index].tenKichCo,
                              style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.check,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
            ]),
          );
  }
}
