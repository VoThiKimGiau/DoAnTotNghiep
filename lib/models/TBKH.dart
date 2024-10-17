class TBKH {
  String maTBKH;
  String khachHang;
  bool daXem;

  TBKH({
    required this.maTBKH,
    required this.khachHang,
    required this.daXem,
  });

  // Chuyển từ JSON thành đối tượng Dart
  factory TBKH.fromJson(Map<String, dynamic> json) {
    return TBKH(
      maTBKH: json['maTBKH'],
      khachHang: json['khachHang'],
      daXem: json['daXem'],
    );
  }

  // Chuyển từ đối tượng Dart thành JSON
  Map<String, dynamic> toJson() {
    return {
      'maTBKH': maTBKH,
      'khachHang': khachHang,
      'daXem': daXem,
    };
  }
}
