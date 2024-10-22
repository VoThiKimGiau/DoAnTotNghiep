class NhanVien {
  final String maNV;
  final String tenNV;
  final String sdt;
  final String email;
  final String chucVu;
  final String tenTK;
  final String matKhau;
  final bool hoatDong;

  NhanVien({
    required this.maNV,
    required this.tenNV,
    required this.sdt,
    required this.email,
    required this.chucVu,
    required this.tenTK,
    required this.matKhau,
    required this.hoatDong
  });
factory NhanVien.fromJson(Map<String,dynamic> json)
  {
    return NhanVien(
      maNV:json['maNV']??'',
      tenNV: json['tenNV'] ?? '',
      sdt: json['sdt'] ?? '',
      email: json['email'] ?? '',
      chucVu: json['chucVu'] ?? '',
      tenTK: json['tenTK'] ?? '',
      matKhau: json['matKhau'] ?? '',
      hoatDong: json['hoatDong'] ?? false,
    );
  }
}
