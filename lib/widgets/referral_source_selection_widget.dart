import 'package:flutter/material.dart';

class ReferralSourceSelectionWidget extends StatelessWidget {
  final String? selectedReferralSource;
  final bool isAffiliatedProfile;
  final bool isOutsideProfile;
  final Function(String) onReferralSourceSelected;

  static const List<Map<String, String>> referralSourceOptions = [
    {'id': 'facebook', 'text': 'Mạng xã hội Facebook'},
    {'id': 'zalo', 'text': 'Ứng dụng Zalo'},
    {'id': 'google', 'text': 'Tìm kiếm trên Google'},
    {'id': 'youtube', 'text': 'Nền tảng YouTube'},
    {'id': 'news', 'text': 'Tin tức từ báo chí'},
    {'id': 'website', 'text': 'Website trung tâm'},
    {'id': 'family', 'text': 'Người thân và bạn bè'},
    {'id': 'staff', 'text': 'Giáo viên hoặc nhân viên trung tâm'},
    {'id': 'other', 'text': 'Nguồn khác'},
  ];

  const ReferralSourceSelectionWidget({
    super.key,
    this.selectedReferralSource,
    required this.isAffiliatedProfile,
    required this.isOutsideProfile,
    required this.onReferralSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescription(),
                const SizedBox(height: 24),
                ...referralSourceOptions.map((option) {
                  return _buildReferralSourceCard(option);
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.teal.shade700,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chọn nguồn thông tin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
          ),
          if (isAffiliatedProfile || isOutsideProfile)
            Wrap(
              spacing: 4,
              children: [
                if (isAffiliatedProfile)
                  Chip(
                    label: const Text(
                      'Liên kết',
                      style: TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.blue.shade50,
                  ),
                if (isOutsideProfile)
                  Chip(
                    label: const Text(
                      'Khoán',
                      style: TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.orange.shade50,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Vui lòng chọn nguồn thông tin bạn biết đến trung tâm:',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildReferralSourceCard(Map<String, String> option) {
    final isSelected = selectedReferralSource == option['id'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 3 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Colors.teal.shade300, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => onReferralSourceSelected(option['id']!),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.teal.shade50
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: isSelected
                      ? Colors.teal.shade700
                      : Colors.grey.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option['text']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Colors.teal.shade700
                        : Colors.grey.shade800,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.teal.shade700,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

