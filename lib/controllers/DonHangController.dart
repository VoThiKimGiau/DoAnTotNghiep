import 'package:datn_cntt304_bandogiadung/models/DonHang.dart';
import 'package:datn_cntt304_bandogiadung/models/ChiTietDonHang.dart';
class DonHangController {
  static List<DonHang> getDonHangs() {
    return [
      DonHang(
        maDH: 'DH001',
        maKH: 'KH001',
        maTTNH: 'TT001',
        thanhTien: 150.00,
        ngayDat: DateTime(2024, 10, 10),
        ngayGiao: DateTime(2024, 10, 15),
        daThanhToan: true,
        trangThaiDH: 'Đang xử lý',
        phuongThucThanhToan: 'Thẻ tín dụng',
      ),
      DonHang(
        maDH: 'DH002',
        maKH: 'KH002',
        maTTNH: 'TT002',
        thanhTien: 200.50,
        ngayDat: DateTime(2024, 10, 11),
        ngayGiao: DateTime(2024, 10, 16),
        daThanhToan: false,
        trangThaiDH: 'Đang giao',
        phuongThucThanhToan: 'Chuyển khoản',
      ),
      DonHang(
        maDH: 'DH003',
        maKH: 'KH003',
        maTTNH: 'TT003',
        thanhTien: 100.75,
        ngayDat: DateTime(2024, 10, 12),
        ngayGiao: DateTime(2024, 10, 17),
        daThanhToan: true,
        trangThaiDH: 'Đã xác nhận',
        phuongThucThanhToan: 'Tiền mặt',
      ),
    ];
  }
  static List<ChiTietDonHang> chiTietDonHangList = [];
  static void setOrderDetails(List<ChiTietDonHang> details) {
    chiTietDonHangList = details;
  }

  int countProductsByOrderId(String orderId) {
    return chiTietDonHangList
        .where((detail) => detail.maDH == orderId)
        .map((detail) => detail.maSP)
        .toSet()
        .length;
  }
  static void  fetchOrderDetail()
  {
    setOrderDetails([
      ChiTietDonHang(maDH: 'DH001', maSP: 'SP001', maKichCo: 'M', maMau: 'Red', soLuong: 2, donGia: 200.0),
      ChiTietDonHang(maDH: 'DH001', maSP: 'SP002', maKichCo: 'L', maMau: 'Blue', soLuong: 1, donGia: 150.0),
      ChiTietDonHang(maDH: 'DH001', maSP: 'SP003', maKichCo: 'S', maMau: 'Green', soLuong: 3, donGia: 100.0),
    ]);
  }
}
