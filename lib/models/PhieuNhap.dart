class PhieuNhap {
  final String maPhieuNhap;
  final String nhaCungCap;
  final String maNV;
  final double tongTien;
  final DateTime ngayDat;  // Đảm bảo là kiểu DateTime
  final DateTime ngayGiao;// Sử dụng kiểu String

  PhieuNhap({
    required this.maPhieuNhap,
    required this.nhaCungCap,
    required this.maNV,
    required this.tongTien,
    required this.ngayDat,
    required this.ngayGiao,
  });

  // Từ JSON sang đối tượng PhieuNhap
  factory PhieuNhap.fromJson(Map<String, dynamic> json) {
    return PhieuNhap(
      maPhieuNhap: json['maPhieuNhap'].trim(),
      nhaCungCap: json['nhaCungCap'].trim(),
      maNV: json['maNV'].trim(),
      tongTien: (json['tongTien'] as num).toDouble(), // Đảm bảo là kiểu double
      ngayDat: DateTime.parse(json['ngayDat']), // Chuyển đổi chuỗi thành DateTime
      ngayGiao: DateTime.parse(json['ngayGiao']), // Giữ nguyên kiểu String
    );
  }

  // Từ đối tượng PhieuNhap sang JSON
  Map<String, dynamic> toJson() {
    return {
      'maPhieuNhap': maPhieuNhap,
      'nhaCungCap': nhaCungCap,
      'maNV': maNV,
      'tongTien': tongTien,
      'ngayDat': ngayDat.toIso8601String(),  // Chuyển đổi DateTime thành chuỗi
      'ngayGiao': ngayGiao.toIso8601String()
    };
  }
}
