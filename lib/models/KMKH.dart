// To parse this JSON data, do
//
//     final kmkh = kmkhFromJson(jsonString);

import 'dart:convert';

KMKH kmkhFromJson(String str) => KMKH.fromJson(json.decode(str));

String kmkhToJson(KMKH data) => json.encode(data.toJson());

class KMKH {
    String khachHang;
    String khuyenMai;
    int soluong;

    KMKH({
        required this.khachHang,
        required this.khuyenMai,
        required this.soluong,
    });

    factory KMKH.fromJson(Map<String, dynamic> json) => KMKH(
        khachHang: json["khachHang"],
        khuyenMai: json["khuyenMai"],
        soluong: json["soluong"],
    );

    Map<String, dynamic> toJson() => {
        "khachHang": khachHang,
        "khuyenMai": khuyenMai,
        "soluong": soluong,
    };
}
