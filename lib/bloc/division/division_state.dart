import 'package:equatable/equatable.dart';
import '../../models/division.dart';

abstract class DivisionState extends Equatable {
  const DivisionState();

  @override
  List<Object?> get props => [];
}

class DivisionInitial extends DivisionState {
  const DivisionInitial();
}

class DivisionLoading extends DivisionState {
  const DivisionLoading();
}

class DivisionLoaded extends DivisionState {
  final List<Division> divisions;

  const DivisionLoaded({required this.divisions});

  @override
  List<Object?> get props => [divisions];
}

class DivisionError extends DivisionState {
  final String message;

  const DivisionError(this.message);

  @override
  List<Object?> get props => [message];
}

