import 'package:equatable/equatable.dart';
import '../../models/course_type.dart';
import '../../models/division.dart';
import '../../models/course_fee.dart';
import '../../models/discount.dart';

class SelectionState extends Equatable {
  final CourseType? selectedCourseType;
  final Division? selectedDivision;
  final Division? selectedTrainingFacility;
  final CourseFee? selectedCourseFee;
  final Discount? selectedDiscount;
  final bool isAffiliatedProfile;
  final bool isOutsideProfile;
  final bool profileTypeConfirmed;
  final String? selectedReferralSource;

  const SelectionState({
    this.selectedCourseType,
    this.selectedDivision,
    this.selectedTrainingFacility,
    this.selectedCourseFee,
    this.selectedDiscount,
    this.isAffiliatedProfile = false,
    this.isOutsideProfile = false,
    this.profileTypeConfirmed = false,
    this.selectedReferralSource,
  });

  SelectionState copyWith({
    CourseType? selectedCourseType,
    Division? selectedDivision,
    Division? selectedTrainingFacility,
    CourseFee? selectedCourseFee,
    Discount? selectedDiscount,
    bool? isAffiliatedProfile,
    bool? isOutsideProfile,
    bool? profileTypeConfirmed,
    String? selectedReferralSource,
    bool clearCourseType = false,
    bool clearDivision = false,
    bool clearTrainingFacility = false,
    bool clearCourseFee = false,
    bool clearDiscount = false,
    bool clearReferralSource = false,
  }) {
    return SelectionState(
      selectedCourseType: clearCourseType ? null : (selectedCourseType ?? this.selectedCourseType),
      selectedDivision: clearDivision ? null : (selectedDivision ?? this.selectedDivision),
      selectedTrainingFacility: clearTrainingFacility
          ? null
          : (selectedTrainingFacility ?? this.selectedTrainingFacility),
      selectedCourseFee: clearCourseFee ? null : (selectedCourseFee ?? this.selectedCourseFee),
      selectedDiscount: clearDiscount ? null : (selectedDiscount ?? this.selectedDiscount),
      isAffiliatedProfile: isAffiliatedProfile ?? this.isAffiliatedProfile,
      isOutsideProfile: isOutsideProfile ?? this.isOutsideProfile,
      profileTypeConfirmed: profileTypeConfirmed ?? this.profileTypeConfirmed,
      selectedReferralSource:
          clearReferralSource ? null : (selectedReferralSource ?? this.selectedReferralSource),
    );
  }

  @override
  List<Object?> get props => [
        selectedCourseType,
        selectedDivision,
        selectedTrainingFacility,
        selectedCourseFee,
        selectedDiscount,
        isAffiliatedProfile,
        isOutsideProfile,
        profileTypeConfirmed,
        selectedReferralSource,
      ];
}

