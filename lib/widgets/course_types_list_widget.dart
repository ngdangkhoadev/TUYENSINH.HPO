import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/course_type.dart';
import '../bloc/course_type/course_type_bloc.dart';
import '../bloc/course_type/course_type_event.dart';

class CourseTypesListWidget extends StatelessWidget {
  final List<CourseType> courseTypes;
  final Function(CourseType) onCourseTypeSelected;

  const CourseTypesListWidget({
    super.key,
    required this.courseTypes,
    required this.onCourseTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CourseTypeBloc>().add(const RefreshCourseTypes());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: courseTypes.length,
              itemBuilder: (context, index) {
                final courseType = courseTypes[index];
                return _buildCourseTypeCard(context, courseType);
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
            color: Colors.blue.shade700,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Danh sách hạng đào tạo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseTypeCard(BuildContext context, CourseType courseType) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => onCourseTypeSelected(courseType),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.school,
                  color: Colors.blue.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseType.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (courseType.fullTitle != null &&
                        courseType.fullTitle != courseType.title) ...[
                      const SizedBox(height: 4),
                      Text(
                        courseType.fullTitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
}

