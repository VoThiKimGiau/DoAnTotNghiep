class KMKH {
    String? khachHang;
    String? khuyenMai;
    int? soluong;

    // Default constructor
    KMKH({this.khachHang, this.khuyenMai, this.soluong});

    // Named constructor to create from JSON
    factory KMKH.fromJson(Map<String, dynamic> json) {
        return KMKH(
            khachHang: json['khachHang']?.trim(),
            khuyenMai: json['khuyenMai']?.trim(),
            soluong: json['soluong'],
        );
    }

    // Method to convert to JSON
    Map<String, dynamic> toJson() {
        return {
            'khachHang': khachHang?.trim(),
            'khuyenMai': khuyenMai?.trim(),
            'soluong': soluong,
        };
    }
}
