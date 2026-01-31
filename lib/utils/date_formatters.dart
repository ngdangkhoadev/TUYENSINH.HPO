/// Helper functions cho format ngày tháng
class DateFormatters {
  /// Chuyển đổi ngày từ dd/MM/yyyy sang ddMMyyyy
  static String convertDateToFormat(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$day$month$year';
      }
      return dateStr.replaceAll('/', '');
    } catch (e) {
      return dateStr.replaceAll('/', '');
    }
  }

  /// Format DateTime thành chuỗi hiển thị với thời gian tương đối
  static String formatDateTime(DateTime dateTime) {
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
}

