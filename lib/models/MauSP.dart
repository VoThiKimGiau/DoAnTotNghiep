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
        maMau: json['maMau'].trim() ?? '',
        tenMau: json['tenMau'].trim() ?? '',
        maHEX: json['maHex'].trim() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'maMau': maMau,
      'tenMau': tenMau,
      'maHex': maHEX,
    };
  }
}
