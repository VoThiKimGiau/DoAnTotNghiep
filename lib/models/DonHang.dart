class DonHang {
  final String maDH;
  final String maKH;
  final String maTTNH;
  final double thanhTien;
  final DateTime ngayDat;
  final DateTime ngayGiao;
  final bool daThanhToan;
  final String trangThaiDH;
  final String phuongThucThanhToan;

  DonHang({
    required this.maDH,
    required this.maKH,
    required this.maTTNH,
    required this.thanhTien,
    required this.ngayDat,
    required this.ngayGiao,
    required this.daThanhToan,
    required this.trangThaiDH,
    required this.phuongThucThanhToan,
  });
}
