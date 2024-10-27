import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductByCategoryScreen extends StatefulWidget {
  final String? maDanhMuc;

  ProductByCategoryScreen({required this.maDanhMuc});

  @override
  _ProductByCategoryScreen createState() => _ProductByCategoryScreen();
}

class _ProductByCategoryScreen extends State<ProductByCategoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 63),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(left: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                    ),
                    child: SvgPicture.asset('assets/icons/arrowleft.svg'),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 36),
                  child: ElevatedButton(
                    onPressed: () {
                      print('b');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Image.asset(
                      'assets/icons/account_icon.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh mục',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gabarito',
                  ),
                  textAlign: TextAlign.left,
                )),
          ),
        ],
      ),
    ));
  }
}
