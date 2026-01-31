import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/division_service.dart';
import 'division_event.dart';
import 'division_state.dart';

class DivisionBloc extends Bloc<DivisionEvent, DivisionState> {
  final DivisionService _divisionService = DivisionService();

  DivisionBloc() : super(const DivisionInitial()) {
    on<LoadDivisions>(_onLoadDivisions);
    on<RefreshDivisions>(_onRefreshDivisions);
  }

  Future<void> _onLoadDivisions(
    LoadDivisions event,
    Emitter<DivisionState> emit,
  ) async {
    emit(const DivisionLoading());

    try {
      final response = await _divisionService.getAllDivisions();

      if (response.error != null) {
        emit(DivisionError(response.error!));
      } else {
        // Lọc chỉ lấy các division active và sắp xếp theo priority (giảm dần)
        // Không filter theo type ở đây, sẽ filter ở UI level
        final activeDivisions = response.list
            .where((division) => division.active)
            .toList()
          ..sort((a, b) {
            if (a.priority == null && b.priority == null) return 0;
            if (a.priority == null) return 1;
            if (b.priority == null) return -1;
            return (b.priority ?? 0).compareTo(a.priority ?? 0);
          });

        emit(DivisionLoaded(divisions: activeDivisions));
      }
    } catch (e) {
      emit(DivisionError('Lỗi tải danh sách đơn vị: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshDivisions(
    RefreshDivisions event,
    Emitter<DivisionState> emit,
  ) async {
    // Giữ nguyên state hiện tại nếu đang có data
    if (state is! DivisionLoaded) {
      emit(const DivisionLoading());
    }

    try {
      final response = await _divisionService.getAllDivisions();

      if (response.error != null) {
        emit(DivisionError(response.error!));
      } else {
        // Lọc chỉ lấy các division active và sắp xếp theo priority (giảm dần)
        // Không filter theo type ở đây, sẽ filter ở UI level
        final activeDivisions = response.list
            .where((division) => division.active)
            .toList()
          ..sort((a, b) {
            if (a.priority == null && b.priority == null) return 0;
            if (a.priority == null) return 1;
            if (b.priority == null) return -1;
            return (b.priority ?? 0).compareTo(a.priority ?? 0);
          });

        emit(DivisionLoaded(divisions: activeDivisions));
      }
    } catch (e) {
      emit(DivisionError('Lỗi tải danh sách đơn vị: ${e.toString()}'));
    }
  }
}

