import 'package:datn_cntt304_bandogiadung/colors/color.dart';
import 'package:datn_cntt304_bandogiadung/controllers/KichCoController.dart';
import 'package:datn_cntt304_bandogiadung/models/KichCo.dart';
import 'package:flutter/material.dart';

class CircleButtonSize extends StatefulWidget {
  final List<String> items;
  final List<String> enabledItems;
  final Function(String) onSelected;

  CircleButtonSize({
    required this.items,
    required this.enabledItems,
    required this.onSelected,
  });

  @override
  _CircleButtonSize createState() => _CircleButtonSize();
}

class _CircleButtonSize extends State<CircleButtonSize> {
  int selectedIndex = -1;
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
          selectedIndex = dsKichCo.indexWhere((kichCo) => widget.enabledItems.contains(kichCo.maKichCo));
          if (selectedIndex != -1) {
            widget.onSelected(dsKichCo[selectedIndex].maKichCo);
          }
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

  void updateSizes(List<String> newItems) {
    setState(() {
      selectedIndex = -1;
      dsKichCo.clear();
    });
    fetchKichCo();
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
                  final isEnabled =
                      widget.enabledItems.contains(dsKichCo[index].maKichCo);
                  return GestureDetector(
                    onTap: isEnabled ? () => onSelected(index) : null,
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selectedIndex == index && isEnabled
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isEnabled
                              ? (selectedIndex == index ? Colors.white : Colors.black)
                              : Colors.grey,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dsKichCo[index].tenKichCo,
                            style: TextStyle(
                              color: isEnabled
                                  ? (selectedIndex == index ? Colors.white : Colors.black)
                                  : Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          if (selectedIndex == index && isEnabled)
                            const Icon(Icons.check,
                                color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ]),
          );
  }
}