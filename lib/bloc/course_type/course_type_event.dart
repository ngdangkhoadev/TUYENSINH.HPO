import 'package:equatable/equatable.dart';

abstract class CourseTypeEvent extends Equatable {
  const CourseTypeEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourseTypes extends CourseTypeEvent {
  const LoadCourseTypes();
}

class RefreshCourseTypes extends CourseTypeEvent {
  const RefreshCourseTypes();
}

