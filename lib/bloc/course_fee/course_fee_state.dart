import 'package:equatable/equatable.dart';
import '../../models/course_fee.dart';

abstract class CourseFeeState extends Equatable {
  const CourseFeeState();

  @override
  List<Object?> get props => [];
}

class CourseFeeInitial extends CourseFeeState {
  const CourseFeeInitial();
}

class CourseFeeLoading extends CourseFeeState {
  const CourseFeeLoading();
}

class CourseFeeLoaded extends CourseFeeState {
  final List<CourseFee> courseFees;

  const CourseFeeLoaded({required this.courseFees});

  @override
  List<Object?> get props => [courseFees];
}

class CourseFeeError extends CourseFeeState {
  final String message;

  const CourseFeeError(this.message);

  @override
  List<Object?> get props => [message];
}

