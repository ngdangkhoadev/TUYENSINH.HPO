import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/course_fee_service.dart';
import 'course_fee_event.dart';
import 'course_fee_state.dart';

class CourseFeeBloc extends Bloc<CourseFeeEvent, CourseFeeState> {
  final CourseFeeService _courseFeeService = CourseFeeService();

  CourseFeeBloc() : super(const CourseFeeInitial()) {
    on<LoadCourseFees>(_onLoadCourseFees);
    on<RefreshCourseFees>(_onRefreshCourseFees);
  }

  Future<void> _onLoadCourseFees(
    LoadCourseFees event,
    Emitter<CourseFeeState> emit,
  ) async {
    emit(const CourseFeeLoading());

    try {
      final response = await _courseFeeService.getAllCourseFees(
        courseType: event.courseType,
        division: event.division,
      );

      if (response.error != null) {
        emit(CourseFeeError(response.error!));
      } else {
        // Sắp xếp: isDefault trước, sau đó theo fee tăng dần
        final sortedFees = response.list
          ..sort((a, b) {
            if (a.isDefault && !b.isDefault) return -1;
            if (!a.isDefault && b.isDefault) return 1;
            return a.fee.compareTo(b.fee);
          });

        emit(CourseFeeLoaded(courseFees: sortedFees));
      }
    } catch (e) {
      emit(CourseFeeError('Lỗi tải danh sách gói học phí: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshCourseFees(
    RefreshCourseFees event,
    Emitter<CourseFeeState> emit,
  ) async {
    // Giữ nguyên state hiện tại nếu đang có data
    if (state is! CourseFeeLoaded) {
      emit(const CourseFeeLoading());
    }

    try {
      final response = await _courseFeeService.getAllCourseFees(
        courseType: event.courseType,
        division: event.division,
      );

      if (response.error != null) {
        emit(CourseFeeError(response.error!));
      } else {
        // Sắp xếp: isDefault trước, sau đó theo fee tăng dần
        final sortedFees = response.list
          ..sort((a, b) {
            if (a.isDefault && !b.isDefault) return -1;
            if (!a.isDefault && b.isDefault) return 1;
            return a.fee.compareTo(b.fee);
          });

        emit(CourseFeeLoaded(courseFees: sortedFees));
      }
    } catch (e) {
      emit(CourseFeeError('Lỗi tải danh sách gói học phí: ${e.toString()}'));
    }
  }
}

