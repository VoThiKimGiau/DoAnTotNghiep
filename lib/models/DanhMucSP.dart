class DanhMucSP {
  final String maDanhMuc;
  final String tenDanhMuc;
  final String anhDanhMuc;

  DanhMucSP({
    required this.maDanhMuc,
    required this.tenDanhMuc,
    required this.anhDanhMuc,
  });

  factory DanhMucSP.fromJson(Map<String, dynamic> json) {
    return DanhMucSP(
      maDanhMuc: json['maDanhMuc'].trim(),
      tenDanhMuc: json['tenDanhMuc'],
      anhDanhMuc: json['anhDanhMuc'].trim(),
    );
  }
}