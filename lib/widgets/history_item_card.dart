import 'package:flutter/material.dart';
import '../models/qr_history.dart';
import '../models/qr_person_info.dart';

/// Widget hiển thị một item trong danh sách lịch sử
class HistoryItemCard extends StatelessWidget {
  final QRHistory item;
  final QRPersonInfo? personInfo;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onToggleSelection;
  final VoidCallback? onCreateProfile;
  final VoidCallback? onOpenUrl;
  final VoidCallback? onDelete;

  const HistoryItemCard({
    super.key,
    required this.item,
    this.personInfo,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    this.onLongPress,
    this.onToggleSelection,
    this.onCreateProfile,
    this.onOpenUrl,
    this.onDelete,
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
    final isPersonInfo = personInfo != null && !personInfo!.isEmpty;
    final isUrl = item.content.startsWith('http://') ||
        item.content.startsWith('https://');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      color: isSelected ? Colors.blue.shade50 : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (isSelectionMode) ...[
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onToggleSelection?.call(),
                ),
                const SizedBox(width: 8),
              ],
              _buildIcon(isPersonInfo),
              const SizedBox(width: 12),
              Expanded(
                child: _buildContent(isPersonInfo),
              ),
              if (!isSelectionMode)
                _buildPopupMenu(isUrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isPersonInfo) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isPersonInfo ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isPersonInfo ? Icons.person : Icons.qr_code,
        color: isPersonInfo ? Colors.green.shade700 : Colors.blue.shade700,
        size: 24,
      ),
    );
  }

  Widget _buildContent(bool isPersonInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isPersonInfo && personInfo != null && personInfo!.fullName != null
              ? personInfo!.fullName!
              : (item.displayValue ?? item.content),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (isPersonInfo && personInfo != null && personInfo!.idNumber != null) ...[
          const SizedBox(height: 4),
          Text(
            'Mã định danh: ${personInfo!.idNumber}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              _formatDateTime(item.scannedAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.format.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPopupMenu(bool isUrl) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.person_add, size: 20),
              SizedBox(width: 8),
              Text('Tạo hồ sơ'),
            ],
          ),
          onTap: () {
            Future.delayed(
              Duration.zero,
              () => onCreateProfile?.call(),
            );
          },
        ),
        if (isUrl)
          PopupMenuItem(
            child: const Row(
              children: [
                Icon(Icons.open_in_new, size: 20),
                SizedBox(width: 8),
                Text('Mở URL'),
              ],
            ),
            onTap: () {
              Future.delayed(
                Duration.zero,
                () => onOpenUrl?.call(),
              );
            },
          ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Xóa', style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () {
            Future.delayed(
              Duration.zero,
              () => onDelete?.call(),
            );
          },
        ),
      ],
    );
  }
}

