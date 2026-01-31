import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/discount_service.dart';
import 'discount_event.dart';
import 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountService _discountService = DiscountService();

  DiscountBloc() : super(const DiscountInitial()) {
    on<LoadDiscounts>(_onLoadDiscounts);
    on<RefreshDiscounts>(_onRefreshDiscounts);
  }

  Future<void> _onLoadDiscounts(
    LoadDiscounts event,
    Emitter<DiscountState> emit,
  ) async {
    emit(const DiscountLoading());

    try {
      final response = await _discountService.getAllDiscounts();

      if (response.error != null) {
        emit(DiscountError(response.error!));
      } else {
        // Lọc chỉ lấy các discount đang active
        final activeDiscounts = response.list
            .where((discount) => discount.isActive)
            .toList()
          ..sort((a, b) {
            // Sắp xếp: isDefault trước, sau đó theo fee giảm dần (giảm giá cao hơn trước)
            if (a.isDefault && !b.isDefault) return -1;
            if (!a.isDefault && b.isDefault) return 1;
            return b.fee.compareTo(a.fee);
          });

        emit(DiscountLoaded(discounts: activeDiscounts));
      }
    } catch (e) {
      emit(DiscountError('Lỗi tải danh sách gói giảm giá: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshDiscounts(
    RefreshDiscounts event,
    Emitter<DiscountState> emit,
  ) async {
    // Giữ nguyên state hiện tại nếu đang có data
    if (state is! DiscountLoaded) {
      emit(const DiscountLoading());
    }

    try {
      final response = await _discountService.getAllDiscounts();

      if (response.error != null) {
        emit(DiscountError(response.error!));
      } else {
        // Lọc chỉ lấy các discount đang active
        final activeDiscounts = response.list
            .where((discount) => discount.isActive)
            .toList()
          ..sort((a, b) {
            // Sắp xếp: isDefault trước, sau đó theo fee giảm dần
            if (a.isDefault && !b.isDefault) return -1;
            if (!a.isDefault && b.isDefault) return 1;
            return b.fee.compareTo(a.fee);
          });

        emit(DiscountLoaded(discounts: activeDiscounts));
      }
    } catch (e) {
      emit(DiscountError('Lỗi tải danh sách gói giảm giá: ${e.toString()}'));
    }
  }
}


