class ChiTietDoiTraDTO {
  final String maCTSP;
  final double gia;
  final int soLuong;

  ChiTietDoiTraDTO({required this.maCTSP, required this.gia, required this.soLuong});

  // Phương thức chuyển đối tượng thành Map để truyền qua API hoặc các hệ thống khác
  Map<String, dynamic> toMap() {
    return {
      'maCTSP': maCTSP,
      'gia': gia,
      'soLuong': soLuong,
    };
  }
}
