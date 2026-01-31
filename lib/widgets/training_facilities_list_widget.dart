import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/division.dart';
import '../models/course_type.dart';
import '../bloc/division/division_bloc.dart';
import '../bloc/division/division_event.dart';

class TrainingFacilitiesListWidget extends StatelessWidget {
  final List<Division> divisions;
  final CourseType? selectedCourseType;
  final Division? selectedDivision;
  final Function(Division) onTrainingFacilitySelected;

  const TrainingFacilitiesListWidget({
    super.key,
    required this.divisions,
    this.selectedCourseType,
    this.selectedDivision,
    required this.onTrainingFacilitySelected,
  });

  @override
  Widget build(BuildContext context) {
    // Lọc chỉ lấy các division có type chứa "coSoDaoTao"
    final trainingFacilities = divisions
        .where((division) {
          if (division.type == null || division.type!.isEmpty) {
            return false;
          }
          return division.type!.contains('coSoDaoTao');
        })
        .toList()
      ..sort((a, b) {
        if (a.priority == null && b.priority == null) return 0;
        if (a.priority == null) return 1;
        if (b.priority == null) return -1;
        return (b.priority ?? 0).compareTo(a.priority ?? 0);
      });

    if (trainingFacilities.isEmpty) {
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
              itemCount: trainingFacilities.length,
              itemBuilder: (context, index) {
                final facility = trainingFacilities[index];
                return _buildFacilityCard(context, facility);
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
            Icons.school,
            color: Colors.orange.shade700,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Danh sách cơ sở đào tạo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
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
          if (selectedDivision != null) ...[
            const SizedBox(width: 8),
            Chip(
              label: Text(
                selectedDivision!.title,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.green.shade50,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFacilityCard(BuildContext context, Division facility) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => onTrainingFacilitySelected(facility),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.school,
                  color: Colors.orange.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (facility.parentType != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _getParentTypeLabel(facility.parentType!),
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
            Icons.school_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Không có cơ sở đào tạo nào',
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

