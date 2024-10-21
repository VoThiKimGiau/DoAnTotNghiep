class KichCo {
  final String maKichCo;
  final String tenKichCo;

  KichCo({
    required this.maKichCo,
    required this.tenKichCo,
  });
  factory KichCo.fromJson(Map<String, dynamic> json) {
    return KichCo(
      maKichCo: json['maKichCo'] ?? '',
      tenKichCo: json['tenKichCo'] ?? '',
    );
  }
}
