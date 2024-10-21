class MauSP {
  final String maMau;
  final String tenMau;
  final String maHEX;

  MauSP({
    required this.maMau,
    required this.tenMau,
    required this.maHEX,
  });
  factory MauSP.fromJson(Map<String, dynamic> json) {
    return MauSP(
        maMau: json['maMau'] ?? '',
        tenMau: json['tenMau'] ?? '',
        maHEX: json['maHex'] ??''
    );
  }

}
