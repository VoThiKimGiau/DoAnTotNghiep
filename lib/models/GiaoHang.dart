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
      maVanDon: json['maVanDon'],                       // Adjusted key to match JSON
      donHang: json['donHang'],                         // Adjusted key to match JSON
      ngayGui: json['ngayGui'] != null ? DateTime.parse(json['ngayGui']) : null, // Parse date
      ngayGiao: json['ngayGiao'] != null ? DateTime.parse(json['ngayGiao']) : null, // Parse date
      trangThai: json['trangThai'],                     // Adjusted key to match JSON
      tienUng: json['tienUng']?.toDouble(),            // Handle potential null
      hinhThuc: json['hinhThuc'],                       // Adjusted key to match JSON
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'maVanDon': maVanDon,                             // Adjusted key to match JSON
      'donHang': donHang,                               // Adjusted key to match JSON
      'ngayGui': ngayGui?.toIso8601String(),           // Format date to ISO 8601
      'ngayGiao': ngayGiao?.toIso8601String(),         // Format date to ISO 8601
      'trangThai': trangThai,                           // Adjusted key to match JSON
      'tienUng': tienUng,                               // Handle potential null
      'hinhThuc': hinhThuc,                             // Adjusted key to match JSON
    };
  }
}
