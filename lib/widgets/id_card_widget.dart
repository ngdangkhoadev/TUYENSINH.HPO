import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/qr_person_info.dart';

class IDCardWidget extends StatelessWidget {
  final QRPersonInfo personInfo;
  final String qrContent;

  const IDCardWidget({
    super.key,
    required this.personInfo,
    required this.qrContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade900,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nội dung chính - 2 cột
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cột trái: Thông tin
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Họ và tên
                      _buildInfoField(
                        label: 'Họ và tên',
                        value: personInfo.fullName ?? 'N/A',
                        isBold: true,
                        fontSize: 16,
                      ),
                      const SizedBox(height: 12),
                      // Mã định danh
                      _buildInfoField(
                        label: 'Mã định danh',
                        value: personInfo.idNumber ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      // CMND/CCCD
                      _buildInfoField(
                        label: 'CMND/CCCD',
                        value: personInfo.idCardNumber ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      // Ngày sinh
                      _buildInfoField(
                        label: 'Ngày sinh',
                        value: personInfo.formattedDateOfBirth ?? personInfo.dateOfBirth ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      // Giới tính
                      _buildInfoField(
                        label: 'Giới tính',
                        value: personInfo.gender ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      // Địa chỉ
                      _buildInfoField(
                        label: 'Địa chỉ',
                        value: personInfo.address ?? 'N/A',
                        isMultiline: true,
                      ),
                      const SizedBox(height: 8),
                      // Ngày cấp
                      _buildInfoField(
                        label: 'Ngày cấp',
                        value: personInfo.formattedIssueDate ?? personInfo.issueDate ?? 'N/A',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Cột phải: QR Code
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: qrContent,
                          version: QrVersions.auto,
                          size: 150,
                          backgroundColor: Colors.white,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mã QR',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Quét mã để xem thông tin',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    bool isBold = false,
    double fontSize = 14,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
            height: isMultiline ? 1.4 : 1.2,
          ),
          maxLines: isMultiline ? null : 1,
          overflow: isMultiline ? null : TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

