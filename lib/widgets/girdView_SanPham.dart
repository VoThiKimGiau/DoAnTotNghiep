import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/models/SanPham.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/ChiTietSanPham.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GridViewSanPham extends StatelessWidget {
  final List<SanPham> itemsSP;
  final String? maKH;

  const GridViewSanPham({
    Key? key,
    required this.itemsSP,
    this.maKH,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StorageService storageService = StorageService();
    SharedFunction sharedFunction = SharedFunction();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 10, // Spacing between columns
        mainAxisSpacing: 10, // Spacing between rows
        childAspectRatio: 0.6, // Aspect ratio of each cell
      ),
      itemCount: itemsSP!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChiTietSanPhamScreen(
                            maSP: itemsSP![index].maSP,
                            maKH: maKH,
                          )));
            },
            child: SizedBox(
              height: 280,
              child: Stack(children: [
                Card(
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                        storageService
                            .getImageUrl(itemsSP![index].hinhAnhMacDinh),
                        height: 185,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          child: Text(
                            itemsSP![index].tenSP,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 4, right: 4, bottom: 16),
                          child: Text(
                            sharedFunction
                                .formatCurrency(itemsSP![index].giaMacDinh),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 1,
                    right: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        print('a');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(18, 18),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/heart.svg',
                        width: 16,
                        height: 16,
                      ),
                    ))
              ]),
            ));
      },
    );
  }
}
