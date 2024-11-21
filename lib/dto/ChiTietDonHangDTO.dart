class ChiTietDonHangDTO {
  String donHang;
  String mactsp;
  int soLuong;
  double donGia;


  // Constructor với các tham số
  ChiTietDonHangDTO({
    required this.donHang,
    required this.mactsp,
    required this.soLuong,
    required this.donGia,
  });

  // Factory constructor từ JSON
  factory ChiTietDonHangDTO.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHangDTO(
      donHang: json['donHang'] ?? '',
      mactsp: json['mactsp'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      donGia: (json['donGia'] ?? 0.0).toDouble(),
    );
  }

  // Chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      'donHang': donHang,
      'mactsp': mactsp,
      'soLuong': soLuong,
      'donGia': donGia,
    };
  }

  // Optional: Override toString for easy printing
  @override
  String toString() {
    return 'ChiTietDonHangDTO(donHang: $donHang, mactsp: $mactsp, soLuong: $soLuong, donGia: $donGia)';
  }

  // Optional: Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChiTietDonHangDTO &&
        donHang == other.donHang &&
        mactsp == other.mactsp &&
        soLuong == other.soLuong &&
        donGia == other.donGia;
  }

  // Optional: hashCode for use in collections
  @override
  int get hashCode {
    return donHang.hashCode ^
    mactsp.hashCode ^
    soLuong.hashCode ^
    donGia.hashCode;
  }

  // Tính tổng tiền
  double tinhTongTien() {
    return soLuong * donGia;
  }
}