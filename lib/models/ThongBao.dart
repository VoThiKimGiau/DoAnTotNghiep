class ThongBao {
  String maTB;
  String noiDung;
  DateTime ngayTB;

  ThongBao({
    required this.maTB,
    required this.noiDung,
    required this.ngayTB,
  });

  factory ThongBao.fromJson(Map<String, dynamic> json) {
    return ThongBao(
      maTB: json['maTB'],
      noiDung: json['noiDung'],
      ngayTB: DateTime.parse(json['ngayTB']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'maTB': maTB,
      'noiDung': noiDung,
      'ngayTB': ngayTB.toIso8601String(),
    };
  }
}
