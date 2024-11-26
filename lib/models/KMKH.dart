class KMKH {
    String? khachHang;
    String? khuyenMai;
    int? soluong;

    // Default constructor
    KMKH({this.khachHang, this.khuyenMai, this.soluong});

    // Named constructor to create from JSON
    factory KMKH.fromJson(Map<String, dynamic> json) {
        return KMKH(
            khachHang: json['makh']?.trim(),
            khuyenMai: json['makhuyenmai']?.trim(),
            soluong: json['sl'],
        );
    }

    // Method to convert to JSON
    Map<String, dynamic> toJson() {
        return {
            'makh': khachHang?.trim(),
            'makhuyenmai': khuyenMai?.trim(),
            'sl': soluong,
        };
    }
}
