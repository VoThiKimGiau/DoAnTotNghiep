class GiaoHang {
  String maVanDon;
  String maDH;
  DateTime? ngayGui;
  DateTime? ngayGiao;
  String trangThai;
  double? tienUng;
  String hinhThucGiaoHang;

  GiaoHang({
    required this.maVanDon,
    required this.maDH,
    this.ngayGui,
    this.ngayGiao,
    required this.trangThai,
    this.tienUng,
    required this.hinhThucGiaoHang,
  });

  // Phương thức chuyển đổi từ JSON sang model
  factory GiaoHang.fromJson(Map<String, dynamic> json) {
    return GiaoHang(
      maVanDon: json['MaVanDon'],
      maDH: json['MaDH'],
      ngayGui: json['NgayGui'] != null ? DateTime.parse(json['NgayGui']) : null,
      ngayGiao: json['NgayGiao'] != null ? DateTime.parse(json['NgayGiao']) : null,
      trangThai: json['TrangThai'],
      tienUng: json['TienUng']?.toDouble(),
      hinhThucGiaoHang: json['HinhThucGiaoHang'],
    );
  }

  // Phương thức chuyển đổi từ model sang JSON
  Map<String, dynamic> toJson() {
    return {
      'MaVanDon': maVanDon,
      'MaDH': maDH,
      'NgayGui': ngayGui?.toIso8601String(),
      'NgayGiao': ngayGiao?.toIso8601String(),
      'TrangThai': trangThai,
      'TienUng': tienUng,
      'HinhThucGiaoHang': hinhThucGiaoHang,
    };
  }
}
