class CourseType {
  final String id;
  final String title;
  final String? fullTitle;
  final String? image;
  final bool active;
  final int? priority;

  CourseType({
    required this.id,
    required this.title,
    this.fullTitle,
    this.image,
    required this.active,
    this.priority,
  });

  factory CourseType.fromJson(Map<String, dynamic> json) {
    return CourseType(
      id: json['_id'] as String,
      title: json['title'] as String,
      fullTitle: json['fullTitle'] as String?,
      image: json['image'] as String?,
      active: json['active'] as bool? ?? true,
      priority: json['priority'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'fullTitle': fullTitle,
      'image': image,
      'active': active,
      'priority': priority,
    };
  }
}

class CourseTypeResponse {
  final List<CourseType> list;
  final String? error;

  CourseTypeResponse({
    required this.list,
    this.error,
  });

  factory CourseTypeResponse.fromJson(Map<String, dynamic> json) {
    return CourseTypeResponse(
      list: (json['list'] as List<dynamic>?)
              ?.map((item) => CourseType.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      error: json['error'] as String?,
    );
  }
}

