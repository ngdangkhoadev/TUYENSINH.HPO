import 'package:flutter/material.dart';
import '../models/course_type.dart';
import '../models/division.dart';
import '../models/course_fee.dart';
import '../models/discount.dart';
import '../models/qr_history.dart';
import 'referral_source_selection_widget.dart';

class ReviewScreenWidget extends StatelessWidget {
  final List<QRHistory>? selectedProfiles;
  final CourseType? selectedCourseType;
  final Division? selectedDivision;
  final Division? selectedTrainingFacility;
  final CourseFee? selectedCourseFee;
  final Discount? selectedDiscount;
  final bool isAffiliatedProfile;
  final bool isOutsideProfile;
  final String? selectedReferralSource;
  final VoidCallback onConfirm;

  const ReviewScreenWidget({
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
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedProfiles != null && selectedProfiles!.isNotEmpty) ...[
                  _buildReviewSection(
                    'Danh sách hồ sơ',
                    '${selectedProfiles!.length} hồ sơ',
                    Icons.person_outline,
                    Colors.blue,
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                ],
                if (selectedCourseType != null) ...[
                  _buildReviewSection(
                    'Hạng đào tạo',
                    selectedCourseType!.title,
                    Icons.school,
                    Colors.blue,
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                ],
                if (selectedDivision != null) ...[
                  _buildReviewSection(
                    'Đơn vị',
                    selectedDivision!.title,
                    Icons.business,
                    Colors.green,
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                ],
                if (selectedTrainingFacility != null) ...[
                  _buildReviewSection(
                    'Cơ sở đào tạo',
                    selectedTrainingFacility!.title,
                    Icons.location_city,
                    Colors.orange,
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                ],
                if (selectedCourseFee != null) ...[
                  _buildReviewSection(
                    'Gói học phí',
                    selectedCourseFee!.name,
                    Icons.account_balance_wallet,
                    Colors.purple,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 38, top: 4, bottom: 12),
                    child: Text(
                      selectedCourseFee!.formattedFee,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                ],
                if (selectedDiscount != null) ...[
                  _buildReviewSection(
                    'Gói giảm giá',
                    selectedDiscount!.name,
                    Icons.local_offer,
                    Colors.red,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 38, top: 4, bottom: 12),
                    child: Text(
                      selectedDiscount!.formattedFee,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                ],
                if (isAffiliatedProfile || isOutsideProfile) ...[
                  _buildReviewSection(
                    'Loại hồ sơ',
                    _getProfileTypeText(),
                    Icons.folder_special,
                    Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 38, top: 8, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isAffiliatedProfile)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
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
                          ),
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
                  Divider(height: 1, color: Colors.grey.shade200),
                ],
                if (selectedReferralSource != null) ...[
                  _buildReviewSection(
                    'Nguồn thông tin',
                    _getReferralSourceText(),
                    Icons.info_outline,
                    Colors.teal,
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.red.shade200, width: 2),
        ),
      ),
      child: Text(
        'Vui lòng kiểm tra lại thông tin trước khi xác nhận',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildReviewSection(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 24, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getProfileTypeText() {
    if (isAffiliatedProfile && isOutsideProfile) {
      return 'Hồ sơ liên kết, Hồ sơ khoán';
    } else if (isAffiliatedProfile) {
      return 'Hồ sơ liên kết';
    } else if (isOutsideProfile) {
      return 'Hồ sơ khoán';
    } else {
      return 'Chưa chọn';
    }
  }

  String _getReferralSourceText() {
    final option = ReferralSourceSelectionWidget.referralSourceOptions.firstWhere(
      (option) => option['id'] == selectedReferralSource,
      orElse: () => {'text': 'Không xác định'},
    );
    return option['text']!;
  }
}

