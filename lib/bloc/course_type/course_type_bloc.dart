import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/course_type_service.dart';
import 'course_type_event.dart';
import 'course_type_state.dart';

class CourseTypeBloc extends Bloc<CourseTypeEvent, CourseTypeState> {
  final CourseTypeService _courseTypeService = CourseTypeService();

  CourseTypeBloc() : super(const CourseTypeInitial()) {
    on<LoadCourseTypes>(_onLoadCourseTypes);
    on<RefreshCourseTypes>(_onRefreshCourseTypes);
  }

  Future<void> _onLoadCourseTypes(
    LoadCourseTypes event,
    Emitter<CourseTypeState> emit,
  ) async {
    emit(const CourseTypeLoading());

    try {
      final response = await _courseTypeService.getAllCourseTypes();

      if (response.error != null) {
        emit(CourseTypeError(response.error!));
      } else {
        // Lọc chỉ lấy các course type active và sắp xếp theo priority
        final activeCourseTypes = response.list
            .where((course) => course.active)
            .toList()
          ..sort((a, b) {
            if (a.priority == null && b.priority == null) return 0;
            if (a.priority == null) return 1;
            if (b.priority == null) return -1;
            return (b.priority ?? 0).compareTo(a.priority ?? 0);
          });

        emit(CourseTypeLoaded(courseTypes: activeCourseTypes));
      }
    } catch (e) {
      emit(CourseTypeError('Lỗi tải danh sách hạng đào tạo: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshCourseTypes(
    RefreshCourseTypes event,
    Emitter<CourseTypeState> emit,
  ) async {
    // Giữ nguyên state hiện tại nếu đang có data
    if (state is! CourseTypeLoaded) {
      emit(const CourseTypeLoading());
    }

    try {
      final response = await _courseTypeService.getAllCourseTypes();

      if (response.error != null) {
        emit(CourseTypeError(response.error!));
      } else {
        // Lọc chỉ lấy các course type active và sắp xếp theo priority
        final activeCourseTypes = response.list
            .where((course) => course.active)
            .toList()
          ..sort((a, b) {
            if (a.priority == null && b.priority == null) return 0;
            if (a.priority == null) return 1;
            if (b.priority == null) return -1;
            return (b.priority ?? 0).compareTo(a.priority ?? 0);
          });

        emit(CourseTypeLoaded(courseTypes: activeCourseTypes));
      }
    } catch (e) {
      emit(CourseTypeError('Lỗi tải danh sách hạng đào tạo: ${e.toString()}'));
    }
  }
}

