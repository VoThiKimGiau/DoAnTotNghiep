import 'ChiTietDoiTraDTO.dart';

class DoiTraDTO {
  final double tongTien;
  final List<ChiTietDoiTraDTO> chiTietDoiTras;

  DoiTraDTO({required this.tongTien, required this.chiTietDoiTras});

  Map<String, dynamic> toMap() {
    return {
      'tongTien': tongTien,
      'chiTietDoiTras': chiTietDoiTras.map((e) => e.toMap()).toList(),
    };
  }
}

