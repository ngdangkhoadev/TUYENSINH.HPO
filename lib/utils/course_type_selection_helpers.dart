import 'package:flutter/material.dart';
import '../models/course_type.dart';
import '../models/division.dart';
import '../models/course_fee.dart';
import '../models/discount.dart';

/// Helper functions for course type selection screen

/// Gets the appropriate title for the AppBar based on current selection state
String getAppBarTitle({
  String? selectedReferralSource,
  bool isAffiliatedProfile = false,
  bool isOutsideProfile = false,
  Discount? selectedDiscount,
  CourseFee? selectedCourseFee,
  Division? selectedDivision,
  Division? selectedTrainingFacility,
  CourseType? selectedCourseType,
  int? selectedProfilesCount,
}) {
  if (selectedReferralSource != null) {
    return 'Xem lại thông tin';
  }
  if ((isAffiliatedProfile || isOutsideProfile) && selectedReferralSource == null) {
    return 'Chọn nguồn thông tin';
  }
  if (selectedDiscount != null) {
    return 'Chọn loại hồ sơ';
  }
  if (selectedCourseFee != null && selectedDiscount == null) {
    return 'Chọn gói giảm giá';
  }
  if (selectedDivision != null && selectedTrainingFacility == null) {
    return 'Chọn cơ sở đào tạo';
  }
  if (selectedTrainingFacility != null && selectedCourseFee == null) {
    return 'Chọn gói học phí';
  }
  if (selectedDivision != null) {
    return 'Chọn cơ sở đào tạo';
  }
  if (selectedCourseType != null) {
    return 'Chọn đơn vị';
  }
  if (selectedProfilesCount != null && selectedProfilesCount > 0) {
    return 'Chọn hạng đào tạo ($selectedProfilesCount hồ sơ)';
  }
  return 'Chọn hạng đào tạo';
}

/// Checks if back button should be shown
bool shouldShowBackButton({
  CourseType? selectedCourseType,
  Division? selectedDivision,
  Division? selectedTrainingFacility,
  CourseFee? selectedCourseFee,
  Discount? selectedDiscount,
  bool isAffiliatedProfile = false,
  bool isOutsideProfile = false,
  bool profileTypeConfirmed = false,
  String? selectedReferralSource,
}) {
  return selectedCourseType != null ||
      selectedDivision != null ||
      selectedTrainingFacility != null ||
      selectedCourseFee != null ||
      selectedDiscount != null ||
      isAffiliatedProfile ||
      isOutsideProfile ||
      profileTypeConfirmed ||
      selectedReferralSource != null;
}

/// Handles back button press logic
void handleBackButtonPress({
  required VoidCallback setState,
  required Function() resetReferralSource,
  required Function() resetProfileType,
  required Function() resetDiscount,
  required Function() resetCourseFee,
  required Function() resetTrainingFacility,
  required Function() resetDivision,
  required Function() resetCourseType,
}) {
  setState();
  if (resetReferralSource() != null) return;
  if (resetProfileType() != null) return;
  if (resetDiscount() != null) return;
  if (resetCourseFee() != null) return;
  if (resetTrainingFacility() != null) return;
  if (resetDivision() != null) return;
  if (resetCourseType() != null) return;
}

/// Gets parent type label in Vietnamese
String getParentTypeLabel(String parentType) {
  switch (parentType) {
    case 'vanPhongTuyenSinh':
      return 'Văn phòng tuyển sinh';
    case 'diem':
      return 'Điểm';
    case 'khoan':
      return 'Khoán';
    case 'trungTam':
      return 'Trung tâm';
    default:
      return parentType;
  }
}

/// Gets profile type text
String getProfileTypeText({
  required bool isAffiliatedProfile,
  required bool isOutsideProfile,
}) {
  if (isAffiliatedProfile && isOutsideProfile) {
    return 'Hồ sơ liên kết, Hồ sơ khoán';
  }
  
  if (isAffiliatedProfile) {
    return 'Hồ sơ liên kết';
  }
  
  if (isOutsideProfile) {
    return 'Hồ sơ khoán';
  }
  
  return 'Chưa chọn';
}

/// Validates if course type is selected before proceeding
bool validateCourseTypeSelection({
  required CourseType? selectedCourseType,
  required BuildContext context,
  String message = 'Phải chọn hạng đào tạo trước khi có thể tiếp tục',
}) {
  if (selectedCourseType == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
    return false;
  }
  return true;
}

