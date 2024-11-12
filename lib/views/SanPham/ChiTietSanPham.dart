import 'package:datn_cntt304_bandogiadung/controllers/ChiTietGioHangController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/ChiTietSPController.dart';
import 'package:datn_cntt304_bandogiadung/controllers/GioHangController.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietGioHang.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietSP.dart';
import 'package:datn_cntt304_bandogiadung/models/KichCo.dart';
import 'package:datn_cntt304_bandogiadung/services/shared_function.dart';
import 'package:datn_cntt304_bandogiadung/services/storage/storage_service.dart';
import 'package:datn_cntt304_bandogiadung/views/SanPham/CircleButtonSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../colors/color.dart';
import '../../controllers/SanPhamController.dart';
import '../../models/SanPham.dart';
import '../../widgets/item_SanPham.dart';
import '../SanPham/CircleButtonColor.dart';
import '../SanPham/CircleButtonSize.dart';

class ChiTietSanPhamScreen extends StatefulWidget {
  final String? maSP, maKH;

  ChiTietSanPhamScreen({required this.maSP, this.maKH});

  @override
  _ChiTietSanPhamScreen createState() => _ChiTietSanPhamScreen();
}

class _ChiTietSanPhamScreen extends State<ChiTietSanPhamScreen> {
  SanPhamController sanPhamController = SanPhamController();
  SanPham? item;
  bool isLoading = true;

  ChiTietSPController chiTietSPController = ChiTietSPController();
  StorageService storageService = StorageService();
  SharedFunction sharedFunction = SharedFunction();

  List<ChiTietSP> dsCTSP = [];
  List<String> dsHinhSP = [];
  List<SanPham>? itemsSP;
  List<String> dsMauSP = [];
  List<String> dsKichCo = [];

  GioHangController gioHangController = GioHangController();

  int _quantity = 1;
  String? maGH;
  String? maSanPham;

  @override
  void initState() {
    super.initState();
    fetchSP(widget.maSP!);
    fetchChiTietSP(widget.maSP!);
    maSanPham = widget.maSP;
  }

  Future<void> fetchSP(String maSanPham) async {
    setState(() {
      isLoading = true;
    });
    try {
      SanPham fetchedItem = await sanPhamController.getProductByMaSP(maSanPham);
      setState(() {
        item = fetchedItem;
        fetchSPTuongTu(item!.danhMuc);
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        item = null; // Ensure item is null if there's an error
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading after fetching
      });
    }
  }

  Future<void> fetchChiTietSP(String maSanPham) async {
    try {
      List<ChiTietSP> fetchedItems =
          await chiTietSPController.layDanhSachCTSPTheoMaSP(maSanPham);
      String maGioH = await fetchMaGH(widget.maKH);

      setState(() {
        dsCTSP = fetchedItems;
        getDSHinhAnh();
        getDSMau();
        getDSKichCo();
        maGH = maGioH;
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        dsCTSP = [];
        dsMauSP = [];
        dsKichCo = [];
        dsHinhSP = [];
      });
    }
  }

  void getDSHinhAnh() {
    dsHinhSP = dsCTSP.map((ct) => ct.maHinhAnh).toList();
  }

  Future<void> fetchSPTuongTu(String maDanhMuc) async {
    try {
      List<SanPham> fetchedItems =
          await sanPhamController.getProductByCategory(maDanhMuc);
      setState(() {
        itemsSP = fetchedItems;
        removeSPHienTai();
      });
    } catch (e) {
      print('Error: $e'); // Handle error
      setState(() {
        itemsSP = []; // Set list to empty on error
      });
    }
  }

  void removeSPHienTai() {
    itemsSP?.removeWhere((sp) => sp.maSP == item?.maSP);
  }

  Future<void> getDSMau() async {
    dsMauSP = dsCTSP.map((ct) => ct.maMau).toSet().toList();
  }

  Future<void> getDSKichCo() async {
    dsKichCo = dsCTSP.map((ct) => ct.maKichCo).toSet().toList();
  }

  Future<String> fetchMaGH(String? maKH) async {
    return gioHangController.getMaGHByMaKH(maKH);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                          backgroundColor: Colors.white,
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
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.white,
                        ),
                        child: SvgPicture.asset('assets/icons/heart.svg'),
                      ),
                    )
                  ],
                ),
              ),
              isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Display loader while loading
                  : item == null
                      ? const Center(child: Text('Không tìm thấy sản phẩm.'))
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: dsHinhSP.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              top: 24,
                                              bottom: 24,
                                              left: 24,
                                              right: 10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              storageService
                                                  .getImageUrl(dsHinhSP[index]),
                                              fit: BoxFit.cover,
                                              width: 160,
                                              height: 250,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 24),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item!.tenSP,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontFamily: 'Gabarito',
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      sharedFunction
                                          .formatCurrency(item!.giaMacDinh),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontFamily: 'Gabarito',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 23, top: 24, right: 25),
                              height: 150,
                              child: SingleChildScrollView(
                                child: Text(
                                  item!.moTa,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 23, top: 24),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Sản phẩm tương tự ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gabarito'),
                                  ),
                                )),
                            Container(
                                height: 280,
                                margin: const EdgeInsets.only(left: 24),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemsSP != null
                                      ? (itemsSP!.length >= 5
                                          ? 5
                                          : itemsSP!.length)
                                      : 0,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChiTietSanPhamScreen(
                                              maSP: itemsSP![index].maSP,
                                              maKH: widget.maKH,
                                            ),
                                          ),
                                        );
                                      },
                                      child: SanPhamItem(item: itemsSP![index]),
                                    );
                                  },
                                )),
                            const SizedBox(height: 15,),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    CustomBottomSheet.show(
                                      context,
                                      "Đặt hàng",
                                      dsCTSP,
                                      dsMauSP,
                                      dsKichCo,
                                      _quantity,
                                      maSanPham ?? '',
                                      maGH ?? '',
                                      item!.hinhAnhMacDinh ?? '',
                                      item!.giaMacDinh ?? 0,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  child: const Text(
                                    'Đặt hàng',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    CustomBottomSheet.show(
                                      context,
                                      "Thêm vào giỏ hàng",
                                      dsCTSP,
                                      dsMauSP,
                                      dsKichCo,
                                      _quantity,
                                      maSanPham ?? '',
                                      maGH ?? '',
                                      item!.hinhAnhMacDinh ?? '',
                                      item!.giaMacDinh ?? 0,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  child: const Text(
                                    'Thêm vào giỏ hàng',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomSheet {
  static void show(
      BuildContext context,
      String buttonText,
      List<ChiTietSP> dsCTSP,
      List<String> dsMau,
      List<String> dsKichCo,
      int initialQuantity,
      String maSP,
      String maGH,
      String maHA,
      double giaMD) {
    int quantity = initialQuantity;
    String? selectedMau;
    String? selectedKichCo;
    ChiTietSP? chiTietSP;
    bool isLoading = false;
    List<String> availableSizes = List.from(dsKichCo);
    List<String> enabledSizes = List.from(dsKichCo);
    double tongTien = 0;
    int slKho = 0;

    SharedFunction sharedFunction = SharedFunction();
    StorageService storageService = StorageService();

    Future<ChiTietSP?> getCTSP(
        String maMau, String maKichCo, String maSP) async {
      for (ChiTietSP ct in dsCTSP) {
        if (ct.maMau == maMau && ct.maKichCo == maKichCo && ct.maSP == maSP) {
          return ct;
        }
      }
      return null;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final bottomSheetHeight = screenHeight * 0.75;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              height: bottomSheetHeight,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 185,
                      margin: const EdgeInsets.only(top: 17, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                storageService.getImageUrl(maHA),
                                fit: BoxFit.cover,
                                width: 180,
                                height: 180,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                sharedFunction.formatCurrency(giaMD),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Kho: $slKho",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 16,
                              ),
                              label: const SizedBox.shrink(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.all(0),
                                minimumSize: const Size(18, 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 17, left: 25),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Màu sắc',
                          style: TextStyle(
                              fontFamily: 'Gabarito',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (dsMau.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else if (dsMau.isNotEmpty)
                      CircleButtonColor(
                        items: dsMau,
                        onSelected: (value) {
                          setState(() {
                            selectedMau = value;
                            updateAvailableSizes(selectedMau, dsCTSP,
                                availableSizes, enabledSizes);
                          });
                        },
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 17, left: 25),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Kích cỡ',
                          style: TextStyle(
                              fontFamily: 'Gabarito',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (dsKichCo.isEmpty)
                      const Center(child: CircularProgressIndicator()),
                    if (dsKichCo.isNotEmpty)
                      CircleButtonSize(
                        items: dsKichCo,
                        enabledItems: enabledSizes,
                        onSelected: (value) async {
                          setState(() {
                            selectedKichCo = value;
                          });

                          if (selectedMau != null &&
                              selectedKichCo != null &&
                              maSP != null) {
                            chiTietSP = await getCTSP(
                                selectedMau!, selectedKichCo!, maSP);
                            if (chiTietSP != null) {
                              setState(() {
                                tongTien = quantity * chiTietSP!.giaBan;
                                maHA = chiTietSP!.maHinhAnh;
                                slKho = chiTietSP!.slKho;
                                giaMD = chiTietSP!.giaBan;
                                if (slKho == 0)
                                  quantity = 0;
                                else
                                  quantity = 1;
                              });
                            }
                          }
                        },
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 17, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Số lượng',
                            style: TextStyle(
                              fontFamily: 'Gabarito',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                      tongTien =
                                          quantity * (chiTietSP?.giaBan ?? 0);
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  minimumSize: const Size(40, 40),
                                  shape: const CircleBorder(),
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.all(12),
                                ),
                                child: const Icon(Icons.remove,
                                    color: Colors.white, size: 16),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 22),
                                child: Text('$quantity',
                                    style: const TextStyle(fontSize: 20)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity < slKho) {
                                      quantity++;
                                      tongTien =
                                          quantity * (chiTietSP?.giaBan ?? 0);
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  minimumSize: const Size(40, 40),
                                  shape: const CircleBorder(),
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.all(12),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 16),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (buttonText == "Thêm vào giỏ hàng" &&
                              isLoading == false) {
                            print(
                                "Selected mau: $selectedMau, selected kich co: $selectedKichCo, maSP: $maSP");
                            if (selectedMau != null &&
                                selectedKichCo != null &&
                                maSP != null) {
                              chiTietSP = await getCTSP(
                                  selectedMau!, selectedKichCo!, maSP);
                              if (chiTietSP == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Thông báo',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: const Text(
                                        'Vui lòng chọn đầy đủ màu sắc và kích cỡ',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Đóng dialog
                                          },
                                          child: const Text(
                                            'Đóng',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (chiTietSP!.slKho == 0) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Thông báo',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: const Text(
                                        'Rất tiếc mặt hàng này đã hết. Xin quý khách vui lòng chọn mặt hàng khác',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Đóng dialog
                                          },
                                          child: const Text(
                                            'Đóng',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                ChiTietGioHangController
                                    chiTietGioHangController =
                                    ChiTietGioHangController();
                                setState(() {
                                  isLoading = true;
                                  tongTien = quantity * chiTietSP!.giaBan;
                                });
                                await chiTietGioHangController
                                    .themChiTietGioHang(
                                  ChiTietGioHang(
                                    maGioHang: maGH,
                                    maCTSP: chiTietSP!.maCTSP,
                                    soLuong: quantity,
                                    donGia: chiTietSP!.giaBan,
                                  ),
                                );
                                setState(() {
                                  isLoading = false;
                                  Navigator.of(context).pop();
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Thêm vào giỏ hàng thành công"),
                                ));
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedMau != null && selectedKichCo != null
                                  ? sharedFunction.formatCurrency(tongTien)
                                  : '0',
                              style: const TextStyle(
                                  fontFamily: 'Gabarito',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    buttonText,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void updateAvailableSizes(String? selectedColor, List<ChiTietSP> dsCTSP,
    List<String> availableSizes, List<String> enabledSizes) {
  availableSizes.clear();
  enabledSizes.clear();

  if (selectedColor != null) {
    final filteredCTSP =
        dsCTSP.where((ct) => ct.maMau == selectedColor).toList();

    final uniqueSizes = filteredCTSP.map((ct) => ct.maKichCo).toSet();

    availableSizes.addAll(uniqueSizes);
    enabledSizes.addAll(uniqueSizes);
  }
}
