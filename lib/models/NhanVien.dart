class NhanVien {
   String maNV;
   String tenNV;
   String sdt;
   String email;
   String chucVu;
   String tenTK;
   String matKhau;
  bool hoatDong;

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
   Map<String, dynamic> toJson() {
     return {
       'maNV': maNV,
       'tenNV': tenNV,
       'sdt': sdt,
       'email': email,
       'chucVu': chucVu,
       'tenTK': tenTK,
       'matKhau': matKhau,
       'hoatDong': hoatDong,
     };
   }
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
