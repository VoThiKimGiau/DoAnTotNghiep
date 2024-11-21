class ChiTietGioHangDTO {
  String maGioHang;
  String maSanPham;
  int soLuong;

  // Constructor với tham số
  ChiTietGioHangDTO({
    required this.maGioHang,
    required this.maSanPham,
    required this.soLuong,
  });

  // Factory constructor để tạo đối tượng từ JSON
  factory ChiTietGioHangDTO.fromJson(Map<String, dynamic> json) {
    return ChiTietGioHangDTO(
      maGioHang: json['maGioHang'] ?? '',
      maSanPham: json['maSanPham'] ?? '',
      soLuong: json['soLuong'] ?? 0,

    );
  }

  // Chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      'maGioHang': maGioHang,
      'maSanPham': maSanPham,
      'soLuong': soLuong,
    };
  }

  // Optional: Override toString for easy printing
  @override
  String toString() {
    return 'ChiTietGioHangDTO(maGioHang: $maGioHang, maSanPham: $maSanPham, soLuong: $soLuong)';
  }

  // Optional: Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChiTietGioHangDTO &&
        maGioHang == other.maGioHang &&
        maSanPham == other.maSanPham &&
        soLuong == other.soLuong;
  }

  // Optional: hashCode for use in collections
  @override
  int get hashCode {
    return maGioHang.hashCode ^
    maSanPham.hashCode ^
    soLuong.hashCode;
  }
}