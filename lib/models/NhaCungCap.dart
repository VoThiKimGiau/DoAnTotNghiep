class NhaCungCap {
  String maNCC;
  String tenNCC;
  String sdt;
  String email;
  String diaChi;

  NhaCungCap({
    required this.maNCC,
    required this.tenNCC,
    required this.sdt,
    required this.email,
    required this.diaChi,
  });

  // Phương thức chuyển JSON thành đối tượng Supplier
  factory NhaCungCap.fromJson(Map<String, dynamic> json) {
    return NhaCungCap(
      maNCC: json['maNCC'].trim(), // Sử dụng trim() để loại bỏ khoảng trắng
      tenNCC: json['tenNCC'],
      sdt: json['sdt'],
      email: json['email'],
      diaChi: json['diaChi'],
    );
  }

  // Phương thức chuyển đối tượng Supplier thành JSON
  Map<String, dynamic> toJson() {
    return {
      'maNCC': maNCC,
      'tenNCC': tenNCC,
      'sdt': sdt,
      'email': email,
      'diaChi': diaChi,
    };
  }
}
