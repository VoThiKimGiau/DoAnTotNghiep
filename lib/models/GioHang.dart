class GioHang {
  final String maGioHang;
  final String khachHang;
  final double tongTien;

  GioHang({
    required this.maGioHang,
    required this.khachHang,
    required this.tongTien,
  });

  // Phương thức để chuyển từ JSON sang đối tượng GioHang
  factory GioHang.fromJson(Map<String, dynamic> json) {
    return GioHang(
      maGioHang: json['maGioHang'],
      khachHang: json['khachHang'],
      tongTien: json['tongTien'].toDouble(), // Chuyển sang kiểu double nếu cần
    );
  }

  // Phương thức để chuyển từ đối tượng GioHang sang JSON
  Map<String, dynamic> toJson() {
    return {
      'maGioHang': maGioHang,
      'khachHang': khachHang,
      'tongTien': tongTien,
    };
  }
}
