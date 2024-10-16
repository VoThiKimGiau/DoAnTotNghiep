class Product {
  String maSP;
  String tenSP;
  String moTa;
  String danhMuc;

  Product({
    required this.maSP,
    required this.tenSP,
    required this.moTa,
    required this.danhMuc,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      maSP: json['maSP'],
      tenSP: json['tenSP'],
      moTa: json['moTa'],
      danhMuc: json['danhMuc'],
    );
  }

  // Method to convert a Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'maSP': maSP,
      'tenSP': tenSP,
      'moTa': moTa,
      'danhMuc': danhMuc,
    };
  }
}
