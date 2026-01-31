import 'package:equatable/equatable.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscounts extends DiscountEvent {
  const LoadDiscounts();
}

class RefreshDiscounts extends DiscountEvent {
  const RefreshDiscounts();
}


