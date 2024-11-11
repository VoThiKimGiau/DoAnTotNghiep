class VatChungDoiTra {
  String maVatChung;
  String lienKetURL;
  String maDoiTra;

  VatChungDoiTra({
    required this.maVatChung,
    required this.lienKetURL,
    required this.maDoiTra,
  });

  factory VatChungDoiTra.fromJson(Map<String, dynamic> json) {
    return VatChungDoiTra(
      maVatChung: json['maVatChung'] ?? '',
      lienKetURL: json['lienKetURL'] ?? '',
      maDoiTra: json['maDoiTra'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maVatChung': maVatChung,
      'lienKetURL': lienKetURL,
      'maDoiTra': maDoiTra,
    };
  }
}
