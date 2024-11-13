class ChiTietGioHang {
  final String maGioHang;
  final String maCTSP;
  final int soLuong;
  final double donGia;
  bool isSelected; // Thêm thuộc tính isSelected

  ChiTietGioHang({
    required this.maGioHang,
    required this.maCTSP,
    required this.soLuong,
    required this.donGia,
    this.isSelected = false, // Mặc định là chưa chọn
  });

  factory ChiTietGioHang.fromJson(Map<String, dynamic> json) {
    return ChiTietGioHang(
      maGioHang: json['gioHang'] ?? '',
      maCTSP: json['sanPham'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      donGia: json['donGia'] ?? 0.0,
      isSelected: json['isSelected'] ?? false, // Thêm isSelected vào JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maGioHang': maGioHang,
      'maSanPham': maCTSP,
      'soLuong': soLuong,
      'donGia': donGia,
      'isSelected': isSelected, // Lưu trạng thái isSelected
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'gioHang': maGioHang,
      'sanPham': maCTSP,
      'soLuong': soLuong,
      'donGia': donGia,
      'isSelected': isSelected, // Lưu trạng thái isSelected khi cập nhật
    };
  }

  ChiTietGioHang copyWith({
    String? maGioHang,
    String? maCTSP,
    int? soLuong,
    double? donGia,
    bool? isSelected, // Thêm tham số isSelected vào copyWith
  }) {
    return ChiTietGioHang(
      maGioHang: maGioHang ?? this.maGioHang,
      maCTSP: maCTSP ?? this.maCTSP,
      soLuong: soLuong ?? this.soLuong,
      donGia: donGia ?? this.donGia,
      isSelected: isSelected ?? this.isSelected, // Cập nhật isSelected
    );
  }
}
