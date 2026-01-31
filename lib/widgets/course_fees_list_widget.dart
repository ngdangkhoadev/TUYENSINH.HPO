import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/course_fee.dart';
import '../models/course_type.dart';
import '../models/division.dart';
import '../bloc/course_fee/course_fee_bloc.dart';
import '../bloc/course_fee/course_fee_event.dart';
import '../bloc/course_fee/course_fee_state.dart';

class CourseFeesListWidget extends StatelessWidget {
  final CourseType selectedCourseType;
  final Division selectedTrainingFacility;
  final Function(CourseFee) onCourseFeeSelected;

  const CourseFeesListWidget({
    super.key,
    required this.selectedCourseType,
    required this.selectedTrainingFacility,
    required this.onCourseFeeSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Load course fees khi vào màn hình này
    final courseFeeBloc = context.read<CourseFeeBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      courseFeeBloc.add(
        LoadCourseFees(
          courseType: selectedCourseType,
          division: selectedTrainingFacility,
        ),
      );
    });

    return BlocBuilder<CourseFeeBloc, CourseFeeState>(
      builder: (context, state) {
        if (state is CourseFeeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CourseFeeError) {
          return _buildErrorState(context, state.message);
        }

        if (state is CourseFeeLoaded) {
          if (state.courseFees.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CourseFeeBloc>().add(
                RefreshCourseFees(
                  courseType: selectedCourseType,
                  division: selectedTrainingFacility,
                ),
              );
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.courseFees.length,
                    itemBuilder: (context, index) {
                      final courseFee = state.courseFees[index];
                      return _buildCourseFeeCard(context, courseFee);
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet,
            color: Colors.purple.shade700,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Danh sách gói học phí',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade700,
              ),
            ),
          ),
          Chip(
            label: Text(
              selectedCourseType.title,
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.blue.shade50,
          ),
          const SizedBox(width: 8),
          Chip(
            label: Text(
              selectedTrainingFacility.title,
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.orange.shade50,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseFeeCard(BuildContext context, CourseFee courseFee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: courseFee.isDefault
            ? BorderSide(color: Colors.purple.shade300, width: 2)
            : BorderSide.none,
      ),
      elevation: courseFee.isDefault ? 3 : 2,
      child: InkWell(
        onTap: () => onCourseFeeSelected(courseFee),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.purple.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            courseFee.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: courseFee.isDefault
                                  ? Colors.purple.shade700
                                  : Colors.grey.shade900,
                            ),
                          ),
                        ),
                        if (courseFee.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Mặc định',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      courseFee.formattedFee,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<CourseFeeBloc>().add(
                LoadCourseFees(
                  courseType: selectedCourseType,
                  division: selectedTrainingFacility,
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Không có gói học phí nào',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
