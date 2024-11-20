class DonHang {
  String maDH;
  String khachHang;
  String thongTinNhanHang;
  double thanhTien;
  DateTime ngayDat;
  DateTime? ngayGiao;
  bool? daThanhToan;
  String trangThaiDH;
  String phuongThucThanhToan;
  String hinhthucgiaohang;

  DonHang({
    required this.maDH,
    required this.khachHang,
    required this.thongTinNhanHang,
    required this.thanhTien,
    required this.ngayDat,
    this.ngayGiao,
    this.daThanhToan,
    required this.trangThaiDH,
    required this.phuongThucThanhToan,
    required this.hinhthucgiaohang,
  });

  factory DonHang.fromJson(Map<String, dynamic> json) {
    return DonHang(
      maDH: json['maDH'],
      khachHang: json['khachHang'],
      thongTinNhanHang: json['thongTinNhanHang'],
      thanhTien: json['thanhTien'].toDouble(),
      ngayDat: DateTime.parse(json['ngayDat']),
      ngayGiao: json['ngayGiao'] != null ? DateTime.parse(json['ngayGiao']) : null,
      daThanhToan: json['daThanhToan'],
      trangThaiDH: json['trangThaiDH'],
      phuongThucThanhToan: json['phuongThucThanhToan'],
      hinhthucgiaohang: json['hinhthucgiaohang'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'khachHang': khachHang,
      'thongTinNhanHang': thongTinNhanHang,
      'thanhTien':thanhTien,
      'ngayDat':ngayDat,
      'daThanhToan':daThanhToan,
      'trangThaiDH':trangThaiDH,
      'phuongThucThanhToan':phuongThucThanhToan,
      'hinhthucgiaohang':hinhthucgiaohang,
    };
  }
}
