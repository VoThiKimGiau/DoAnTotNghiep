class DoiTra {
  String maDoiTra;
  String donHang;
  String lyDo;
  DateTime? ngayDoiTra;
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
    this.ngayDoiTra,
    this.ngayHoanTien,
    this.ngayTraHang,
    required this.trangThai,
    required this.tenTK,
    required this.soTK,
    required this.tenNganHang,
    required this.tienHoanTra,
  });

  Map<String, dynamic> toJson() {
    return {
      'madoitra': maDoiTra,
      'madonhang': donHang,
      'lydo': lyDo,
      'ngayxacnhan': ngayDoiTra?.toIso8601String(),
      'ngayhoantien': ngayHoanTien?.toIso8601String(),
      'ngaykhtrahang': ngayTraHang?.toIso8601String(),
      'trangthai': trangThai,
      'tentk': tenTK,
      'sotk': soTK,
      'tennganhang': tenNganHang,
      'tienhoantra': tienHoanTra,
    };
  }

  factory DoiTra.fromJson(Map<String, dynamic> json) {
    return DoiTra(
      maDoiTra: json['madoitra'],
      donHang: json['madonhang'],
      lyDo: json['lydo'],
      ngayDoiTra: DateTime.tryParse(json['ngayxacnhan']),
      ngayHoanTien: DateTime.tryParse(json['ngayhoantien']),
      ngayTraHang: DateTime.tryParse(json['ngaykhtrahang']),
      trangThai: json['trangthai'],
      tenTK: json['tentk'],
      soTK: json['sotk'],
      tenNganHang: json['tennganhang'],
      tienHoanTra: json['tienhoantra'],
    );
  }
}
