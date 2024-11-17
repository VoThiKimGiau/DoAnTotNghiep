
class TTNhanHang {
  final String maTTNH;
  final String hoTen;
  final String diaChi;
  final String sdt;
  final String maKH;
  late final bool macDinh;

  TTNhanHang({
    required this.maTTNH,
    required this.hoTen,
    required this.diaChi,
    required this.sdt,
    required this.maKH,
    required this.macDinh,
  });

  factory TTNhanHang.fromJson(Map<String, dynamic> json) {
    return TTNhanHang(
      maTTNH: json['maTTNH']?.toString() ?? '',
      hoTen: json['hoTen']?.toString() ?? '',
      diaChi: json['diaChi']?.toString() ?? '',
      sdt: json['sdt']?.toString() ?? '',
      maKH: json['maKH']?.toString() ?? '',
      macDinh: json['macDinh'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maTTNH': maTTNH,
      'hoTen': hoTen,
      'diaChi': diaChi,
      'sdt': sdt,
      'maKH': maKH,
      'macDinh': macDinh,
    };
  }
}
