class SanPham {
  final String maSP;
  final String tenSP;
  final String moTa;
  final String danhMuc;
  final String hinhAnhMacDinh;
  final double giaMacDinh;

  SanPham({
    required this.maSP,
    required this.tenSP,
    required this.moTa,
    required this.danhMuc,
    required this.hinhAnhMacDinh,
    required this.giaMacDinh,
  });

  // Factory method to create a Product from JSON
  factory SanPham.fromJson(Map<String, dynamic> json) {
    return SanPham(
      maSP: json['maSP'],
      tenSP: json['tenSP'],
      moTa: json['moTa'],
      danhMuc: json['danhMuc'],
      hinhAnhMacDinh: json['hinhAnhMacDinh'],
      giaMacDinh: json['giaMacDinh'],
    );
  }

  // Method to convert a Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'maSP': maSP,
      'tenSP': tenSP,
      'moTa': moTa,
      'danhMuc': danhMuc,
      'hinhAnhMacDinh': hinhAnhMacDinh,
      'giaMacDinh': giaMacDinh,
    };
  }
}
