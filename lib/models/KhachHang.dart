class KhachHang {
  String? maKH;
  String? tenKH;
  String? sdt;
  String? email;
  bool gioiTinh;
  DateTime? ngaySinh;
  String? tenTK;
  String? matKhau;
  bool hoatDong;

  KhachHang({
    this.maKH,
    this.tenKH,
    this.sdt,
    this.email,
    required this.gioiTinh,
    this.ngaySinh,
    this.tenTK,
    this.matKhau,
    required this.hoatDong,
  });

  factory KhachHang.fromJson(Map<String, dynamic> json) {
    return KhachHang(
      maKH: json['maKH'] as String?,  // Allow nullable values
      tenKH: json['tenKH'] as String?,
      sdt: json['sdt'] as String?,
      email: json['email'] as String?,
      gioiTinh: json['gioiTinh'] as bool? ?? false,  // Fallback to false if null
      ngaySinh: json['ngaySinh'] != null ? DateTime.parse(json['ngaySinh']) : null,  // Handle nullable date
      tenTK: json['tenTK'] as String?,
      matKhau: json['matKhau'] as String?,
      hoatDong: json['hoatDong'] as bool? ?? true,  // Fallback to true if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maKH': maKH,
      'tenKH': tenKH,
      'sdt': sdt,
      'email': email,
      'gioiTinh': gioiTinh,
      'ngaySinh': ngaySinh?.toIso8601String(),  // Handle nullable date
      'tenTK': tenTK,
      'matKhau': matKhau,
      'hoatDong': hoatDong,
    };
  }
}
