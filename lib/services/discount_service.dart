import '../models/discount.dart';
import 'api_service.dart';

class DiscountService {
  final ApiService _apiService = ApiService();

  /// Lấy danh sách gói giảm giá
  Future<DiscountResponse> getAllDiscounts() async {
    try {
      // Tạo query parameters với timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final queryParams = {'t': timestamp.toString()};

      // Gọi API với GET
      final response = await _apiService.get<Map<String, dynamic>>(
        '/api/discount/all',
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        return DiscountResponse.fromJson(response.data!);
      } else {
        return DiscountResponse(
          list: [],
          error: response.message ?? 'Không thể tải danh sách gói giảm giá',
        );
      }
    } catch (e) {
      return DiscountResponse(
        list: [],
        error: 'Lỗi: ${e.toString()}',
      );
    }
  }
}


