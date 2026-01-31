import '../models/division.dart';
import 'api_service.dart';

class DivisionService {
  final ApiService _apiService = ApiService();

  /// Lấy danh sách tất cả divisions
  Future<DivisionResponse> getAllDivisions() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/api/division/all',
      );

      if (response.success && response.data != null) {
        return DivisionResponse.fromJson(response.data!);
      } else {
        return DivisionResponse(
          list: [],
          error: response.message ?? 'Không thể tải danh sách đơn vị',
        );
      }
    } catch (e) {
      return DivisionResponse(
        list: [],
        error: 'Lỗi: ${e.toString()}',
      );
    }
  }
}

