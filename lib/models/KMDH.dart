
class KMDH {
  final String donHang;
  final String khuyenMai;

  KMDH({required this.donHang, required this.khuyenMai});

  factory KMDH.fromJson(Map<String, dynamic> json) {
    return KMDH(
      donHang: json['donHang'] ?? '',
      khuyenMai: json['khuyenMai'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donHang': donHang,
      'khuyenMai': khuyenMai,
    };
  }
}
