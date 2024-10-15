class TaiKhoan {
  final String tenTK;
  final String matKhau;
  final String? maNV;
  final String? maKH;
  final bool hoatDong;

  TaiKhoan({
    required this.tenTK,
    required this.matKhau,
    this.maNV,
    this.maKH,
    required this.hoatDong,
  });
}
