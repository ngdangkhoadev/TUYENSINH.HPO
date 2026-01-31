import '../models/course_fee.dart';
import '../models/division.dart';
import '../models/course_type.dart';
import 'api_service.dart';

class CourseFeeService {
  final ApiService _apiService = ApiService();

  /// Lấy danh sách gói học phí
  Future<CourseFeeResponse> getAllCourseFees({
    required CourseType courseType,
    required Division division,
  }) async {
    try {
      // Tạo form data
      final formData = <String, String>{
        'courseType': courseType.id,
        'division[_id]': division.id,
        'division[isOutside]': (division.isOutside ?? false).toString(),
        'division[isAffiliatedSchool]': (division.isAffiliatedSchool ?? false).toString(),
      };

      // Tạo query parameters với timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final queryParams = {'t': timestamp.toString()};

      // Gọi API với POST và form-urlencoded
      final response = await _apiService.post<Map<String, dynamic>>(
        '/api/course-fee/all',
        body: formData,
        isFormUrlEncoded: true,
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        return CourseFeeResponse.fromJson(response.data!);
      } else {
        return CourseFeeResponse(
          list: [],
          error: response.message ?? 'Không thể tải danh sách gói học phí',
        );
      }
    } catch (e) {
      return CourseFeeResponse(
        list: [],
        error: 'Lỗi: ${e.toString()}',
      );
    }
  }
}

