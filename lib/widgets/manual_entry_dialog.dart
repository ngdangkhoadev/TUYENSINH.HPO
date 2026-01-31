import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/qr_person_info.dart';
import '../models/qr_history.dart';
import '../services/qr_history_service.dart';
import '../bloc/history/history_bloc.dart';
import '../bloc/history/history_event.dart';

/// Dialog để thêm hồ sơ thủ công
class ManualEntryDialog extends StatefulWidget {
  final BuildContext parentContext;

  const ManualEntryDialog({
    super.key,
    required this.parentContext,
  });

  @override
  State<ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<ManualEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idNumberController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _idNumberFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _firstNameFocus = FocusNode();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _idNumberController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _dateOfBirthController.dispose();
    _idNumberFocus.dispose();
    _lastNameFocus.dispose();
    _firstNameFocus.dispose();
    super.dispose();
  }

  String _convertDateToFormat(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$day$month$year';
      }
      return dateStr.replaceAll('/', '');
    } catch (e) {
      return dateStr.replaceAll('/', '');
    }
  }

  String _personInfoToQRContent(QRPersonInfo personInfo) {
    return '${personInfo.idNumber ?? ''}|'
        '${personInfo.idCardNumber ?? ''}|'
        '${personInfo.fullName ?? ''}|'
        '${personInfo.dateOfBirth ?? ''}|'
        '${personInfo.gender ?? ''}|'
        '${personInfo.address ?? ''}|'
        '${personInfo.issueDate ?? ''}';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('vi', 'VN'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      setState(() {
        _dateOfBirthController.text = '$day/$month/$year';
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final idNumber = _idNumberController.text.trim();
      final lastName = _lastNameController.text.trim();
      final firstName = _firstNameController.text.trim();
      final dateOfBirth = _convertDateToFormat(_dateOfBirthController.text.trim());
      final fullName = '$lastName $firstName';

      final personInfo = QRPersonInfo(
        idNumber: idNumber,
        idCardNumber: null,
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        gender: null,
        address: null,
        issueDate: null,
      );

      final qrContent = _personInfoToQRContent(personInfo);

      final qrHistory = QRHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: qrContent,
        format: 'manual',
        scannedAt: DateTime.now(),
        displayValue: fullName,
      );

      final historyService = QRHistoryService();
      await historyService.addToHistory(qrHistory);

      if (widget.parentContext.mounted) {
        Navigator.of(context).pop();
        
        // Reload history từ parent context
        final historyBloc = widget.parentContext.read<HistoryBloc>();
        historyBloc.add(const LoadHistory());

        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Đã thêm hồ sơ: $fullName'),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildForm(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_add_alt_1, size: 28, color: Colors.blue),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Thêm hồ sơ thủ công',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            tooltip: 'Đóng',
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Flexible(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIdNumberField(),
              const SizedBox(height: 20),
              _buildLastNameField(),
              const SizedBox(height: 20),
              _buildFirstNameField(),
              const SizedBox(height: 20),
              _buildDateOfBirthField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdNumberField() {
    return TextFormField(
      controller: _idNumberController,
      focusNode: _idNumberFocus,
      decoration: InputDecoration(
        labelText: 'Mã định danh',
        hintText: 'Nhập mã định danh',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.badge_outlined),
        filled: true,
        fillColor: Colors.grey.shade50,
        helperText: 'Mã định danh cá nhân (12 số)',
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ],
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_lastNameFocus);
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập mã định danh';
        }
        if (value.length < 9 || value.length > 12) {
          return 'Mã định danh phải từ 9-12 số';
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      focusNode: _lastNameFocus,
      decoration: InputDecoration(
        labelText: 'Họ',
        hintText: 'Nhập họ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.person_outline),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_firstNameFocus);
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập họ';
        }
        if (value.trim().length < 2) {
          return 'Họ phải có ít nhất 2 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      focusNode: _firstNameFocus,
      decoration: InputDecoration(
        labelText: 'Tên',
        hintText: 'Nhập tên',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.person),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).unfocus();
        _selectDate();
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập tên';
        }
        if (value.trim().length < 2) {
          return 'Tên phải có ít nhất 2 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return TextFormField(
      controller: _dateOfBirthController,
      decoration: InputDecoration(
        labelText: 'Ngày sinh',
        hintText: 'Chọn ngày sinh',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: IconButton(
          icon: const Icon(Icons.event),
          onPressed: _isSubmitting ? null : _selectDate,
          tooltip: 'Chọn ngày',
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        helperText: 'Định dạng: dd/MM/yyyy',
      ),
      readOnly: true,
      onTap: _isSubmitting ? null : _selectDate,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng chọn ngày sinh';
        }
        final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
        if (!dateRegex.hasMatch(value)) {
          return 'Định dạng không đúng (dd/MM/yyyy)';
        }
        return null;
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Hủy', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Thêm hồ sơ', style: TextStyle(fontSize: 16)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

