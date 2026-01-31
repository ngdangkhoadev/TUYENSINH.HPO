import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/division.dart';
import '../models/course_type.dart';
import '../bloc/division/division_bloc.dart';
import '../bloc/division/division_event.dart';

class DivisionsListWidget extends StatelessWidget {
  final List<Division> divisions;
  final CourseType? selectedCourseType;
  final Function(Division) onDivisionSelected;

  const DivisionsListWidget({
    super.key,
    required this.divisions,
    this.selectedCourseType,
    required this.onDivisionSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Lọc chỉ lấy các division có type chứa "vanPhongTuyenSinh"
    final filteredDivisions = divisions
        .where((division) {
          if (division.type == null || division.type!.isEmpty) {
            return false;
          }
          return division.type!.contains('vanPhongTuyenSinh');
        })
        .toList();

    if (filteredDivisions.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DivisionBloc>().add(const RefreshDivisions());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredDivisions.length,
              itemBuilder: (context, index) {
                final division = filteredDivisions[index];
                return _buildDivisionCard(context, division);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.business,
            color: Colors.green.shade700,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Danh sách đơn vị',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
          if (selectedCourseType != null)
            Chip(
              label: Text(
                selectedCourseType!.title,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue.shade50,
            ),
        ],
      ),
    );
  }

  Widget _buildDivisionCard(BuildContext context, Division division) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => onDivisionSelected(division),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.business,
                  color: Colors.green.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      division.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (division.parentType != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _getParentTypeLabel(division.parentType!),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Không có đơn vị nào',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _getParentTypeLabel(String parentType) {
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
}

