class QRPersonInfo {
  final String? idNumber; // Mã định danh
  final String? idCardNumber; // Mã chứng minh nhân dân
  final String? fullName; // Tên
  final String? dateOfBirth; // Ngày tháng năm sinh
  final String? gender; // Giới tính
  final String? address; // Địa chỉ
  final String? issueDate; // Ngày cấp

  QRPersonInfo({
    this.idNumber,
    this.idCardNumber,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.issueDate,
  });

  // Parse từ chuỗi QR content
  factory QRPersonInfo.fromQRContent(String content) {
    final parts = content.split('|');
    
    if (parts.length >= 7) {
      return QRPersonInfo(
        idNumber: parts[0].trim().isEmpty ? null : parts[0].trim(),
        idCardNumber: parts[1].trim().isEmpty ? null : parts[1].trim(),
        fullName: parts[2].trim().isEmpty ? null : parts[2].trim(),
        dateOfBirth: parts[3].trim().isEmpty ? null : parts[3].trim(),
        gender: parts[4].trim().isEmpty ? null : parts[4].trim(),
        address: parts[5].trim().isEmpty ? null : parts[5].trim(),
        issueDate: parts[6].trim().isEmpty ? null : parts[6].trim(),
      );
    }
    
    return QRPersonInfo();
  }

  // Kiểm tra xem có phải là QR code thông tin cá nhân không
  static bool isPersonInfoQR(String content) {
    final parts = content.split('|');
    return parts.length >= 7;
  }

  // Format ngày tháng năm sinh (ddMMyyyy -> dd/MM/yyyy)
  String? get formattedDateOfBirth {
    if (dateOfBirth == null || dateOfBirth!.length != 8) return dateOfBirth;
    try {
      final day = dateOfBirth!.substring(0, 2);
      final month = dateOfBirth!.substring(2, 4);
      final year = dateOfBirth!.substring(4, 8);
      return '$day/$month/$year';
    } catch (e) {
      return dateOfBirth;
    }
  }

  // Format ngày cấp (ddMMyyyy -> dd/MM/yyyy)
  String? get formattedIssueDate {
    if (issueDate == null || issueDate!.length != 8) return issueDate;
    try {
      final day = issueDate!.substring(0, 2);
      final month = issueDate!.substring(2, 4);
      final year = issueDate!.substring(4, 8);
      return '$day/$month/$year';
    } catch (e) {
      return issueDate;
    }
  }

  bool get isEmpty {
    return idNumber == null &&
        idCardNumber == null &&
        fullName == null &&
        dateOfBirth == null &&
        gender == null &&
        address == null &&
        issueDate == null;
  }
}

