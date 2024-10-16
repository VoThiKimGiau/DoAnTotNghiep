
class GiaoHang {
  String maVanDon;
  String donHang;
  DateTime? ngayGui;
  DateTime? ngayGiao;
  String trangThai;
  String hinhThuc;
  double tienUng;

  GiaoHang({
    required this.maVanDon,
    required this.donHang,
    this.ngayGui,
    this.ngayGiao,
    required this.trangThai,
    required this.hinhThuc,
    required this.tienUng,
  });

  factory GiaoHang.fromJson(Map<String, dynamic> json) {
    return GiaoHang(
      maVanDon: json['mavandon'] as String,
      donHang: json['madh'] as String,
      ngayGui: DateTime.tryParse(json['ngaygui'] as String),
      ngayGiao: DateTime.tryParse(json['ngaygiao'] as String),
      trangThai: json['trangthai'] as String,
      hinhThuc: json['hinhthucgiaohang'] as String,
      tienUng: (json['tienung'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mavandon': maVanDon,
      'madh': donHang,
      'ngaygui': ngayGui?.toIso8601String(),
      'ngaygiao': ngayGiao?.toIso8601String(),
      'trangthai': trangThai,
      'hinhthucgiaohang': hinhThuc,
      'tienung': tienUng,
    };
  }
}
