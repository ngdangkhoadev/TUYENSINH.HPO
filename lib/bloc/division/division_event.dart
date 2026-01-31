import 'package:equatable/equatable.dart';

abstract class DivisionEvent extends Equatable {
  const DivisionEvent();

  @override
  List<Object?> get props => [];
}

class LoadDivisions extends DivisionEvent {
  const LoadDivisions();
}

class RefreshDivisions extends DivisionEvent {
  const RefreshDivisions();
}

