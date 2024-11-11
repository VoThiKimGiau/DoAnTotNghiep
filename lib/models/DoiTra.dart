class DoiTra {
  String maDoiTra;
  String donHang;
  String lyDo;
  DateTime? ngayDoiTra;
  DateTime? ngayXacNhan;
  DateTime? ngayHoanTien;
  DateTime? ngayTraHang;
  String trangThai;
  String tenTK;
  String soTK;
  String tenNganHang;
  double tienHoanTra;

  DoiTra({
    required this.maDoiTra,
    required this.donHang,
    required this.lyDo,
    this.ngayXacNhan,
    this.ngayDoiTra,
    this.ngayHoanTien,
    this.ngayTraHang,
    required this.trangThai,
    required this.tenTK,
    required this.soTK,
    required this.tenNganHang,
    required this.tienHoanTra,
  });

  factory DoiTra.fromJson(Map<String, dynamic> json) {
    return DoiTra(
      maDoiTra: json['maDoiTra'] as String? ?? '',
      donHang: json['donHang'] as String? ?? '',
      lyDo: json['lyDo'] as String? ?? '',
      ngayDoiTra: json['ngayDoiTra'] != null ? DateTime.tryParse(json['ngayDoiTra'] as String) : null,
      ngayXacNhan: json['ngayXacNhan'] != null ? DateTime.tryParse(json['ngayXacNhan'] as String) : null,
      ngayHoanTien: json['ngayHoanTien'] != null ? DateTime.tryParse(json['ngayHoanTien'] as String) : null,
      ngayTraHang: json['ngayTraHang'] != null ? DateTime.tryParse(json['ngayTraHang'] as String) : null,
      trangThai: json['trangThai'] as String? ?? '',
      tenTK: json['tenTK'] as String? ?? '',
      soTK: json['soTK'] as String? ?? '',
      tenNganHang: json['tenNganHang'] as String? ?? '',
      tienHoanTra: (json['tienHoanTra'] as num?)?.toDouble() ?? 0.0,
    );
  }


  // Convert the Dart object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'maDoiTra': maDoiTra,
      'donHang': donHang,
      'lyDo': lyDo,
      'ngayDoiTra':ngayDoiTra?.toIso8601String(),
      'ngayXacNhan': ngayXacNhan?.toIso8601String(),
      'ngayHoanTien': ngayHoanTien?.toIso8601String(),
      'ngayTraHang': ngayTraHang?.toIso8601String(),
      'trangThai': trangThai,
      'tenTK': tenTK,
      'soTK': soTK,
      'tenNganHang': tenNganHang,
      'tienHoanTra': tienHoanTra
    };
  }


}
