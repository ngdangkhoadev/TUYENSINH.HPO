import 'package:flutter/material.dart';
import '../models/qr_person_info.dart';
import 'id_card_widget.dart';

class PersonInfoCard extends StatelessWidget {
  final QRPersonInfo personInfo;
  final String qrContent;

  const PersonInfoCard({
    super.key,
    required this.personInfo,
    required this.qrContent,
  });

  @override
  Widget build(BuildContext context) {
    return IDCardWidget(
      personInfo: personInfo,
      qrContent: qrContent,
    );
  }
}

// Giữ lại code cũ để tương thích ngược (nếu cần)
class PersonInfoCardOld extends StatelessWidget {
  final QRPersonInfo personInfo;

  const PersonInfoCardOld({
    super.key,
    required this.personInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.blue.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Hàng 1: Tên (highlight)
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Họ và tên',
            value: personInfo.fullName ?? 'N/A',
            isHighlight: true,
          ),
          const SizedBox(height: 12),
          // Hàng 2: Mã định danh và CMND/CCCD (2 cột)
          Row(
            children: [
              Expanded(
                child: _buildInfoRowCompact(
                  icon: Icons.badge,
                  label: 'Mã định danh',
                  value: personInfo.idNumber ?? 'N/A',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoRowCompact(
                  icon: Icons.credit_card,
                  label: 'CMND/CCCD',
                  value: personInfo.idCardNumber ?? 'N/A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Hàng 3: Ngày sinh, Giới tính, Ngày cấp (3 cột)
          Row(
            children: [
              Expanded(
                child: _buildInfoRowCompact(
                  icon: Icons.cake,
                  label: 'Ngày sinh',
                  value: personInfo.formattedDateOfBirth ?? personInfo.dateOfBirth ?? 'N/A',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoRowCompact(
                  icon: Icons.wc,
                  label: 'Giới tính',
                  value: personInfo.gender ?? 'N/A',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoRowCompact(
                  icon: Icons.calendar_today,
                  label: 'Ngày cấp',
                  value: personInfo.formattedIssueDate ?? personInfo.issueDate ?? 'N/A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Hàng 4: Địa chỉ (full width)
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Địa chỉ',
            value: personInfo.address ?? 'N/A',
            isMultiline: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: isHighlight ? 16 : 14,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                  color: isHighlight ? Colors.blue.shade900 : Colors.black87,
                ),
                maxLines: isMultiline ? null : 1,
                overflow: isMultiline ? null : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowCompact({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.blue.shade700),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

