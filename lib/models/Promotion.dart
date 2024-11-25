// To parse this JSON data, do
//
//     final promotion = promotionFromJson(jsonString);

import 'dart:convert';

Promotion promotionFromJson(String str) => Promotion.fromJson(json.decode(str));

String promotionToJson(Promotion data) => json.encode(data.toJson());

class Promotion {
    String maKm;
    String moTa;
    String loaiKm;
    DateTime ngayBatDau;
    DateTime ngayKetThuc;
    double triGiaGiam;
    double triGiaToiThieu;
    int slkhNhan;

    Promotion({
        required this.maKm,
        required this.moTa,
        required this.loaiKm,
        required this.ngayBatDau,
        required this.ngayKetThuc,
        required this.triGiaGiam,
        required this.triGiaToiThieu,
        required this.slkhNhan,
    });

    factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        maKm: json["maKM"],
        moTa: json["moTa"],
        loaiKm: json["loaiKM"],
        ngayBatDau: DateTime.parse(json["ngayBatDau"]),
        ngayKetThuc: DateTime.parse(json["ngayKetThuc"]),
        triGiaGiam: json["triGiaGiam"],
        triGiaToiThieu: json["triGiaToiThieu"],
        slkhNhan: json["slkhNhan"],
    );

    Map<String, dynamic> toJson() => {
        "maKM": maKm,
        "moTa": moTa,
        "loaiKM": loaiKm,
        "ngayBatDau": "${ngayBatDau.year.toString().padLeft(4, '0')}-${ngayBatDau.month.toString().padLeft(2, '0')}-${ngayBatDau.day.toString().padLeft(2, '0')}",
        "ngayKetThuc": "${ngayKetThuc.year.toString().padLeft(4, '0')}-${ngayKetThuc.month.toString().padLeft(2, '0')}-${ngayKetThuc.day.toString().padLeft(2, '0')}",
        "triGiaGiam": triGiaGiam,
        "triGiaToiThieu": triGiaToiThieu,
        "triGiaToiDa": 0,
        "slkhNhan": slkhNhan,
    };
}
