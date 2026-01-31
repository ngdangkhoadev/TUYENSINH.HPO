import '../models/course_type.dart';
import 'api_service.dart';

class CourseTypeService {
  final ApiService _apiService = ApiService();

  /// Lấy danh sách tất cả hạng đào tạo
  Future<CourseTypeResponse> getAllCourseTypes() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/api/course-type/all',
      );

      if (response.success && response.data != null) {
        return CourseTypeResponse.fromJson(response.data!);
      } else {
        return CourseTypeResponse(
          list: [],
          error: response.message ?? 'Không thể tải danh sách hạng đào tạo',
        );
      }
    } catch (e) {
      return CourseTypeResponse(
        list: [],
        error: 'Lỗi: ${e.toString()}',
      );
    }
  }
}

