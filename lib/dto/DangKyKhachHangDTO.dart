class DangKyKhachHangDTO {
  String tenKH;
  String sdt;
  String email;
  bool? gioiTinh;
  DateTime? ngaySinh;
  String tenTK;
  String matKhau;
  String matKhauNhapLai;

  DangKyKhachHangDTO({
    required this.tenKH,
    required this.sdt,
    required this.email,
    this.gioiTinh,
    this.ngaySinh,
    required this.tenTK,
    required this.matKhau,
    required this.matKhauNhapLai,
  });

  factory DangKyKhachHangDTO.fromJson(Map<String, dynamic> json) {
    return DangKyKhachHangDTO(
      tenKH: json['tenKH'] as String,
      sdt: json['sdt'] as String,
      email: json['email'] as String,
      gioiTinh: json['gioiTinh'] as bool? ?? false,
      ngaySinh: json['ngaySinh'] != null ? DateTime.parse(json['ngaySinh']) : null,
      tenTK: json['tenTK'] as String,
      matKhau: json['matKhau'] as String,
      matKhauNhapLai: json['matKhauNhapLai'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenKH': tenKH,
      'sdt': sdt,
      'email': email,
      'gioiTinh': gioiTinh,
      'ngaySinh': ngaySinh?.toIso8601String(),
      'tenTK': tenTK,
      'matKhau': matKhau,
      'matKhauNhapLai': matKhauNhapLai,
    };
  }
}
