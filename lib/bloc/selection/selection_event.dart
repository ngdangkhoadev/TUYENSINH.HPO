import 'package:equatable/equatable.dart';
import '../../models/course_type.dart';
import '../../models/division.dart';
import '../../models/course_fee.dart';
import '../../models/discount.dart';

abstract class SelectionEvent extends Equatable {
  const SelectionEvent();

  @override
  List<Object?> get props => [];
}

class SelectCourseType extends SelectionEvent {
  final CourseType courseType;

  const SelectCourseType(this.courseType);

  @override
  List<Object?> get props => [courseType];
}

class SelectDivision extends SelectionEvent {
  final Division division;

  const SelectDivision(this.division);

  @override
  List<Object?> get props => [division];
}

class SelectTrainingFacility extends SelectionEvent {
  final Division facility;

  const SelectTrainingFacility(this.facility);

  @override
  List<Object?> get props => [facility];
}

class SelectCourseFee extends SelectionEvent {
  final CourseFee courseFee;

  const SelectCourseFee(this.courseFee);

  @override
  List<Object?> get props => [courseFee];
}

class SelectDiscount extends SelectionEvent {
  final Discount discount;

  const SelectDiscount(this.discount);

  @override
  List<Object?> get props => [discount];
}

class SetAffiliatedProfile extends SelectionEvent {
  final bool value;

  const SetAffiliatedProfile(this.value);

  @override
  List<Object?> get props => [value];
}

class SetOutsideProfile extends SelectionEvent {
  final bool value;

  const SetOutsideProfile(this.value);

  @override
  List<Object?> get props => [value];
}

class ConfirmProfileType extends SelectionEvent {
  const ConfirmProfileType();
}

class SelectReferralSource extends SelectionEvent {
  final String source;

  const SelectReferralSource(this.source);

  @override
  List<Object?> get props => [source];
}

class ResetSelection extends SelectionEvent {
  const ResetSelection();
}

class GoBack extends SelectionEvent {
  const GoBack();
}

class ResetCourseType extends SelectionEvent {
  const ResetCourseType();
}

class ResetDivision extends SelectionEvent {
  const ResetDivision();
}

class ResetTrainingFacility extends SelectionEvent {
  const ResetTrainingFacility();
}

class ResetCourseFee extends SelectionEvent {
  const ResetCourseFee();
}

class ResetDiscount extends SelectionEvent {
  const ResetDiscount();
}

class ResetReferralSource extends SelectionEvent {
  const ResetReferralSource();
}

class ResetProfileType extends SelectionEvent {
  const ResetProfileType();
}

