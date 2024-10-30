class ChiTietPhieuNhap {
  final String maPN; // Mã phiếu nhập
  final String maCTSP; // Mã chi tiết sản phẩm
  final double donGia; // Đơn giá
  final int soLuong; // Số lượng

  ChiTietPhieuNhap({
    required this.maPN,
    required this.maCTSP,
    required this.donGia,
    required this.soLuong,
  });

  // Phương thức từ JSON
  factory ChiTietPhieuNhap.fromJson(Map<String, dynamic> json) {
    return ChiTietPhieuNhap(
      maPN: json['maPhieu'].trim(),
      maCTSP: json['maSP'].trim(),
      soLuong: json['soLuong'],
      donGia: json['donGia'].toDouble(),
    );
  }

  // Phương thức để chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'maPhieu': maPN,
      'maSP': maCTSP,
      'soLuong': soLuong,
      'donGia': donGia,
    };
  }
}
