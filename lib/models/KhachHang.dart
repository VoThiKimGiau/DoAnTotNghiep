class KhachHang {
  String maKH;
  String tenKH;
  String sdt;
  String email;
  bool gioiTinh;
  DateTime ngaySinh;

  KhachHang({
    required this.maKH,
    required this.tenKH,
    required this.sdt,
    required this.email,
    required this.gioiTinh,
    required this.ngaySinh,
  });

  // Factory constructor to create KhachHang from JSON
  factory KhachHang.fromJson(Map<String, dynamic> json) {
    return KhachHang(
      maKH: json['maKH'],
      tenKH: json['tenKH'],
      sdt: json['sdt'],
      email: json['email'],
      gioiTinh: json['gioiTinh'],
      ngaySinh: DateTime.parse(json['ngaySinh']),
    );
  }

  // Method to convert KhachHang object to JSON
  Map<String, dynamic> toJson() {
    return {
      'maKH': maKH,
      'tenKH': tenKH,
      'sdt': sdt,
      'email': email,
      'gioiTinh': gioiTinh,
      'ngaySinh': ngaySinh.toIso8601String(),
    };
  }
}
