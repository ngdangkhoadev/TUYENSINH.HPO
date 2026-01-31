import 'package:equatable/equatable.dart';
import '../../models/course_type.dart';
import '../../models/division.dart';

abstract class CourseFeeEvent extends Equatable {
  const CourseFeeEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourseFees extends CourseFeeEvent {
  final CourseType courseType;
  final Division division;

  const LoadCourseFees({
    required this.courseType,
    required this.division,
  });

  @override
  List<Object?> get props => [courseType, division];
}

class RefreshCourseFees extends CourseFeeEvent {
  final CourseType courseType;
  final Division division;

  const RefreshCourseFees({
    required this.courseType,
    required this.division,
  });

  @override
  List<Object?> get props => [courseType, division];
}

