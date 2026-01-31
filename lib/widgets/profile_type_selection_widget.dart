import 'package:flutter/material.dart';
import '../models/discount.dart';

class ProfileTypeSelectionWidget extends StatelessWidget {
  final bool isAffiliatedProfile;
  final bool isOutsideProfile;
  final Discount? selectedDiscount;
  final Function(bool) onAffiliatedProfileChanged;
  final Function(bool) onOutsideProfileChanged;
  final VoidCallback onConfirm;

  const ProfileTypeSelectionWidget({
    super.key,
    required this.isAffiliatedProfile,
    required this.isOutsideProfile,
    required this.selectedDiscount,
    required this.onAffiliatedProfileChanged,
    required this.onOutsideProfileChanged,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescription(),
                const SizedBox(height: 12),
                _buildAffiliatedProfileCheckbox(),
                const SizedBox(height: 8),
                _buildOutsideProfileCheckbox(),
                const SizedBox(height: 12),
                if (isAffiliatedProfile || isOutsideProfile)
                  _buildSelectedInfo(),
                const SizedBox(height: 8),
                _buildConfirmButton(),
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
            Icons.folder_special,
            color: Colors.blue.shade700,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chọn loại hồ sơ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          if (selectedDiscount != null)
            Chip(
              label: Text(
                selectedDiscount!.name,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.red.shade50,
            ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vui lòng chọn loại hồ sơ:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Bạn có thể chọn 1 hoặc nhiều loại hồ sơ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildAffiliatedProfileCheckbox() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isAffiliatedProfile
            ? BorderSide(color: Colors.blue.shade300, width: 2)
            : BorderSide.none,
      ),
      child: CheckboxListTile(
        value: isAffiliatedProfile,
        onChanged: (value) => onAffiliatedProfileChanged(value ?? false),
        title: Text(
          'Hồ sơ liên kết',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isAffiliatedProfile
                ? Colors.blue.shade700
                : Colors.grey.shade800,
          ),
        ),
        subtitle: Text(
          'Chọn nếu hồ sơ thuộc loại liên kết',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        activeColor: Colors.blue.shade700,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  Widget _buildOutsideProfileCheckbox() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOutsideProfile
            ? BorderSide(color: Colors.orange.shade300, width: 2)
            : BorderSide.none,
      ),
      child: CheckboxListTile(
        value: isOutsideProfile,
        onChanged: (value) => onOutsideProfileChanged(value ?? false),
        title: Text(
          'Hồ sơ khoán',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isOutsideProfile
                ? Colors.orange.shade700
                : Colors.grey.shade800,
          ),
        ),
        subtitle: Text(
          'Chọn nếu hồ sơ thuộc loại khoán',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        activeColor: Colors.orange.shade700,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  Widget _buildSelectedInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue.shade700,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getSelectedProfileTypeCountText(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (isAffiliatedProfile || isOutsideProfile) ? onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            disabledBackgroundColor: Colors.grey.shade300,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isAffiliatedProfile || isOutsideProfile) ...[
                const Icon(Icons.check_circle, size: 20, color: Colors.white),
                const SizedBox(width: 8),
              ],
              const Text(
                'Xác nhận',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSelectedProfileTypeCountText() {
    int count = 0;
    if (isAffiliatedProfile) count++;
    if (isOutsideProfile) count++;
    
    if (count == 0) {
      return 'Vui lòng chọn ít nhất 1 loại hồ sơ';
    } else if (count == 1) {
      String selected = isAffiliatedProfile ? 'Hồ sơ liên kết' : 'Hồ sơ khoán';
      return 'Đã chọn: $selected';
    } else {
      return 'Đã chọn: Hồ sơ liên kết và Hồ sơ khoán (2 loại)';
    }
  }
}

