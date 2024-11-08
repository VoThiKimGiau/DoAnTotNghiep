import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/MauSPController.dart';
import 'package:datn_cntt304_bandogiadung/models/MauSP.dart';
import 'package:flutter/material.dart';

class CircleButtonColor extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelected;

  CircleButtonColor({
    required this.items,
    required this.onSelected,
  });

  @override
  _CircleButtonColor createState() => _CircleButtonColor();
}

class _CircleButtonColor extends State<CircleButtonColor> {
  int selectedIndex = -1; // Không có nút nào được chọn

  MauSPController mauSPController = MauSPController();
  List<MauSP> dsMauSP = [];
  bool isLoading = false;

  void onSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelected(
        dsMauSP[index].maMau); // Call onSelected with the selected color
  }

  @override
  void initState() {
    super.initState();
    fetchMauSP();
  }

  Future<void> fetchMauSP() async {
    try {
      List<MauSP> fetchedItems = [];
      setState(() {
        isLoading = true;
      });

      for (String item in widget.items) {
        MauSP itemMauSP = await mauSPController.layMauTheoMa(item);
        fetchedItems.add(itemMauSP);
      }

      setState(() {
        dsMauSP = fetchedItems;
        if (dsMauSP.isNotEmpty) {
          selectedIndex = 0; // Set default selection to the first item
          widget.onSelected(
              dsMauSP[0].maMau); // Notify the parent of the default selection
        }

        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        dsMauSP = [];
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
                            SizedBox(
                              width: 100,
                              child: Text(
                                dsMauSP.isNotEmpty ? dsMauSP[index].tenMau : '',
                                style: TextStyle(
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(int.parse(dsMauSP[index]
                                    .maHEX
                                    .replaceFirst('#', '0xFF'))),
                                border: Border.all(
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Color(int.parse(dsMauSP[index]
                                          .maHEX
                                          .replaceFirst('#', '0xFF'))),
                                  width: 3.0,
                                ),
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
