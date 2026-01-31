import 'package:equatable/equatable.dart';
import '../../models/discount.dart';

abstract class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object?> get props => [];
}

class DiscountInitial extends DiscountState {
  const DiscountInitial();
}

class DiscountLoading extends DiscountState {
  const DiscountLoading();
}

class DiscountLoaded extends DiscountState {
  final List<Discount> discounts;

  const DiscountLoaded({required this.discounts});

  @override
  List<Object?> get props => [discounts];
}

class DiscountError extends DiscountState {
  final String message;

  const DiscountError(this.message);

  @override
  List<Object?> get props => [message];
}


