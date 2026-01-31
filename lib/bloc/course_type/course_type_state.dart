import 'package:equatable/equatable.dart';
import '../../models/course_type.dart';

abstract class CourseTypeState extends Equatable {
  const CourseTypeState();

  @override
  List<Object?> get props => [];
}

class CourseTypeInitial extends CourseTypeState {
  const CourseTypeInitial();
}

class CourseTypeLoading extends CourseTypeState {
  const CourseTypeLoading();
}

class CourseTypeLoaded extends CourseTypeState {
  final List<CourseType> courseTypes;

  const CourseTypeLoaded({required this.courseTypes});

  @override
  List<Object?> get props => [courseTypes];
}

class CourseTypeError extends CourseTypeState {
  final String message;

  const CourseTypeError(this.message);

  @override
  List<Object?> get props => [message];
}

