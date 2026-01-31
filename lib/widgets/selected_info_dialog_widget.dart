import 'package:flutter/material.dart';
import '../models/course_type.dart';
import '../models/division.dart';
import '../models/course_fee.dart';
import '../models/discount.dart';
import '../models/qr_history.dart';
import '../widgets/referral_source_selection_widget.dart';
import '../utils/course_type_selection_helpers.dart';

class SelectedInfoDialogWidget extends StatelessWidget {
  final List<QRHistory>? selectedProfiles;
  final CourseType? selectedCourseType;
  final Division? selectedDivision;
  final Division? selectedTrainingFacility;
  final CourseFee? selectedCourseFee;
  final Discount? selectedDiscount;
  final bool isAffiliatedProfile;
  final bool isOutsideProfile;
  final String? selectedReferralSource;
  final Function()? onResetCourseType;
  final Function()? onResetDivision;
  final Function()? onResetTrainingFacility;
  final Function()? onResetCourseFee;
  final Function()? onResetDiscount;
  final Function()? onResetReferralSource;
  final Function()? onResetProfileType;

  const SelectedInfoDialogWidget({
    super.key,
    this.selectedProfiles,
    this.selectedCourseType,
    this.selectedDivision,
    this.selectedTrainingFacility,
    this.selectedCourseFee,
    this.selectedDiscount,
    required this.isAffiliatedProfile,
    required this.isOutsideProfile,
    this.selectedReferralSource,
    this.onResetCourseType,
    this.onResetDivision,
    this.onResetTrainingFacility,
    this.onResetCourseFee,
    this.onResetDiscount,
    this.onResetReferralSource,
    this.onResetProfileType,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue.shade700,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text('Thông tin đã chọn'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedProfiles != null && selectedProfiles!.isNotEmpty) ...[
              _buildInfoSection(
                'Danh sách hồ sơ',
                '${selectedProfiles!.length} hồ sơ',
                Icons.person_outline,
                Colors.blue,
              ),
              const SizedBox(height: 16),
            ],
            if (selectedCourseType != null) ...[
              _buildInfoSectionWithAction(
                'Hạng đào tạo',
                selectedCourseType!.title,
                Icons.school,
                Colors.blue,
                onReset: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onResetCourseType?.call();
                  });
                },
              ),
              if (selectedCourseType!.fullTitle != null &&
                  selectedCourseType!.fullTitle != selectedCourseType!.title)
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4),
                  child: Text(
                    selectedCourseType!.fullTitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ] else
              _buildInfoSection(
                'Hạng đào tạo',
                'Chưa chọn',
                Icons.school_outlined,
                Colors.grey,
              ),
            const SizedBox(height: 16),
            if (selectedDivision != null) ...[
              _buildInfoSectionWithAction(
                'Đơn vị',
                selectedDivision!.title,
                Icons.business,
                Colors.green,
                onReset: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onResetDivision?.call();
                  });
                },
              ),
              if (selectedDivision!.parentType != null)
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4),
                  child: Text(
                    getParentTypeLabel(selectedDivision!.parentType!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ] else
              _buildInfoSection(
                'Đơn vị',
                'Chưa chọn',
                Icons.business_outlined,
                Colors.grey,
              ),
            const SizedBox(height: 16),
            if (selectedTrainingFacility != null) ...[
              _buildInfoSectionWithAction(
                'Cơ sở đào tạo',
                selectedTrainingFacility!.title,
                Icons.school,
                Colors.orange,
                onReset: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onResetTrainingFacility?.call();
                  });
                },
              ),
              if (selectedTrainingFacility!.parentType != null)
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4),
                  child: Text(
                    getParentTypeLabel(selectedTrainingFacility!.parentType!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ] else
              _buildInfoSection(
                'Cơ sở đào tạo',
                'Chưa chọn',
                Icons.school_outlined,
                Colors.grey,
              ),
            const SizedBox(height: 16),
            if (selectedCourseFee != null) ...[
              _buildInfoSectionWithAction(
                'Gói học phí',
                selectedCourseFee!.name,
                Icons.account_balance_wallet,
                Colors.purple,
                onReset: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onResetCourseFee?.call();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 4),
                child: Text(
                  selectedCourseFee!.formattedFee,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else
              _buildInfoSection(
                'Gói học phí',
                'Chưa chọn',
                Icons.account_balance_wallet_outlined,
                Colors.grey,
              ),
            const SizedBox(height: 16),
            if (selectedDiscount != null) ...[
              _buildInfoSectionWithAction(
                'Gói giảm giá',
                selectedDiscount!.name,
                Icons.local_offer,
                Colors.red,
                onReset: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onResetDiscount?.call();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 4),
                child: Text(
                  selectedDiscount!.formattedFee,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ] else
              _buildInfoSection(
                'Gói giảm giá',
                'Chưa chọn',
                Icons.local_offer_outlined,
                Colors.grey,
              ),
            const SizedBox(height: 16),
            if (isAffiliatedProfile || isOutsideProfile) ...[
              _buildInfoSectionWithAction(
                'Loại hồ sơ',
                getProfileTypeText(
                  isAffiliatedProfile: isAffiliatedProfile,
                  isOutsideProfile: isOutsideProfile,
                ),
                Icons.folder_special,
                Colors.blue,
                onReset: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onResetProfileType?.call();
                  });
                },
              ),
            ] else
              _buildInfoSection(
                'Loại hồ sơ',
                'Chưa chọn',
                Icons.folder_special_outlined,
                Colors.grey,
              ),
            if (isAffiliatedProfile || isOutsideProfile) ...[
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isAffiliatedProfile)
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Hồ sơ liên kết',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    if (isAffiliatedProfile && isOutsideProfile)
                      const SizedBox(height: 4),
                    if (isOutsideProfile)
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Hồ sơ khoán',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 16),
            if (selectedReferralSource != null) ...[
              _buildInfoSectionWithAction(
                'Nguồn thông tin',
                ReferralSourceSelectionWidget.referralSourceOptions.firstWhere(
                  (option) => option['id'] == selectedReferralSource,
                  orElse: () => {'text': 'Không xác định'},
                )['text']!,
                Icons.info_outline,
                Colors.teal,
                onReset: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onResetReferralSource?.call();
                  });
                },
              ),
            ] else
              _buildInfoSection(
                'Nguồn thông tin',
                'Chưa chọn',
                Icons.info_outline,
                Colors.grey,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Đóng'),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSectionWithAction(
    String label,
    String value,
    IconData icon,
    Color color, {
    required VoidCallback onReset,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onReset,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.refresh,
                size: 16,
                color: Colors.orange.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                'Chọn lại',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

