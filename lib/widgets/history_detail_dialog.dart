import 'package:flutter/material.dart';
import '../models/qr_history.dart';
import '../models/qr_person_info.dart';
import '../widgets/person_info_card.dart';

/// Dialog hiển thị chi tiết lịch sử quét QR
class HistoryDetailDialog extends StatelessWidget {
  final QRHistory item;
  final QRPersonInfo? personInfo;
  final VoidCallback? onCreateProfile;

  const HistoryDetailDialog({
    super.key,
    required this.item,
    this.personInfo,
    this.onCreateProfile,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    String relativeTime;

    if (difference.inMinutes < 1) {
      relativeTime = 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      relativeTime = '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      relativeTime = '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      relativeTime = 'Hôm qua';
    } else if (difference.inDays == 2) {
      relativeTime = 'Hôm kia';
    } else if (difference.inDays < 7) {
      relativeTime = '${difference.inDays} ngày trước';
    } else {
      relativeTime = '${difference.inDays} ngày trước';
    }

    final date =
        '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';

    return '$date ($relativeTime)';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (personInfo != null && !personInfo!.isEmpty)
                      PersonInfoCard(
                        personInfo: personInfo!,
                        qrContent: item.content,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SelectableText(
                          item.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Thời gian: ${_formatDateTime(item.scannedAt)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Đóng'),
                ),
                const SizedBox(width: 8),
                if (onCreateProfile != null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCreateProfile?.call();
                    },
                    child: const Text('Tạo hồ sơ'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

