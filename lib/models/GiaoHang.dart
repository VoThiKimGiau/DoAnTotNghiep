class GiaoHang {
  String maVanDon;               // Code for the delivery
  String donHang;                // Order code
  DateTime? ngayGui;             // Send date
  DateTime? ngayGiao;            // Delivery date
  String trangThai;              // Delivery status
  double? tienUng;               // Advance payment
  String hinhThuc;               // Delivery method

  GiaoHang({
    required this.maVanDon,
    required this.donHang,
    this.ngayGui,
    this.ngayGiao,
    required this.trangThai,
    this.tienUng,
    required this.hinhThuc,
  });

  // Convert JSON to model
  factory GiaoHang.fromJson(Map<String, dynamic> json) {
    return GiaoHang(
      maVanDon: json['maVanDon'],
      donHang: json['donHang'],
      ngayGui: json['ngayGui'] != null ? DateTime.parse(json['ngayGui']) : null,
      ngayGiao: json['ngayGiao'] != null ? DateTime.parse(json['ngayGiao']) : null,
      trangThai: json['trangThai'],
      tienUng: json['tienUng']?.toDouble(),
      hinhThuc: json['hinhThuc'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'maVanDon': maVanDon,
      'donHang': donHang,
      'ngayGui': ngayGui?.toIso8601String(),
      'ngayGiao': ngayGiao?.toIso8601String(),
      'trangThai': trangThai,
      'tienUng': tienUng,
      'hinhThuc': hinhThuc,
    };
  }
}
