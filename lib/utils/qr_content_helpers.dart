import '../models/qr_person_info.dart';

/// Helper functions cho xử lý QR content
class QRContentHelpers {
  /// Chuyển đổi QRPersonInfo thành chuỗi QR content
  static String personInfoToQRContent(QRPersonInfo personInfo) {
    return '${personInfo.idNumber ?? ''}|'
        '${personInfo.idCardNumber ?? ''}|'
        '${personInfo.fullName ?? ''}|'
        '${personInfo.dateOfBirth ?? ''}|'
        '${personInfo.gender ?? ''}|'
        '${personInfo.address ?? ''}|'
        '${personInfo.issueDate ?? ''}';
  }
}

