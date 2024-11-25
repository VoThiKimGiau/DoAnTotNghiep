class KhuyenMai {
  String maKM;
  String moTa;
  String loaiKM;
  DateTime ngayBatDau;
  DateTime ngayKetThuc;
  double triGiaGiam;
  double triGiaToiThieu;
  int slkhNhan;

  // Constructor
  KhuyenMai({
    required this.maKM,
    required this.moTa,
    required this.loaiKM,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.triGiaGiam,
    required this.triGiaToiThieu,
    required this.slkhNhan,
  });

  // Factory method to create KhuyenMai from JSON
  factory KhuyenMai.fromJson(Map<String, dynamic> json) {
    return KhuyenMai(
      maKM: json['maKM'] ?? '',
      moTa: json['moTa'] ?? '',
      loaiKM: json['loaiKM'] ?? '',
      ngayBatDau: DateTime.parse(json['ngayBatDau']),
      ngayKetThuc: DateTime.parse(json['ngayKetThuc']),
      triGiaGiam: json['triGiaGiam']?.toDouble() ?? 0.0,
      triGiaToiThieu: json['triGiaToiThieu']?.toDouble() ?? 0.0,
      slkhNhan: json['slkhNhan'] ?? 0,
    );
  }

  // Method to convert KhuyenMai to JSON
  Map<String, dynamic> toJson() {
    return {
      'maKM': maKM,
      'moTa': moTa,
      'loaiKM': loaiKM,
      'ngayBatDau': ngayBatDau.toIso8601String(),
      'ngayKetThuc': ngayKetThuc.toIso8601String(),
      'triGiaGiam': triGiaGiam,
      'triGiaToiThieu': triGiaToiThieu,
      'slkhNhan': slkhNhan,
    };
  }
}
