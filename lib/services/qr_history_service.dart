import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qr_history.dart';

class QRHistoryService {
  static const String _historyKey = 'qr_history';

  // Lấy tất cả lịch sử quét
  Future<List<QRHistory>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);
      
      if (historyJson == null) {
        return [];
      }

      final List<dynamic> historyList = json.decode(historyJson);
      return historyList
          .map((item) => QRHistory.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    } catch (e) {
      return [];
    }
  }

  // Thêm một QR code vào lịch sử
  Future<void> addToHistory(QRHistory qrHistory) async {
    try {
      final history = await getHistory();
      
      // Kiểm tra xem QR code đã tồn tại chưa (tránh trùng lặp)
      final exists = history.any((item) => 
        item.content == qrHistory.content && 
        item.scannedAt.difference(qrHistory.scannedAt).inMinutes < 1
      );
      
      if (!exists) {
        history.insert(0, qrHistory);
        
        // Giới hạn lịch sử tối đa 100 mục
        if (history.length > 100) {
          history.removeRange(100, history.length);
        }
        
        final prefs = await SharedPreferences.getInstance();
        final historyJson = json.encode(
          history.map((item) => item.toJson()).toList(),
        );
        await prefs.setString(_historyKey, historyJson);
      }
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  // Xóa một mục khỏi lịch sử
  Future<void> deleteFromHistory(String id) async {
    try {
      final history = await getHistory();
      history.removeWhere((item) => item.id == id);
      
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(
        history.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_historyKey, historyJson);
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  // Xóa toàn bộ lịch sử
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }
}

