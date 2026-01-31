class CourseFee {
  final String id;
  final String name;
  final int fee;
  final bool isDefault;
  final bool isDaily;
  final bool isCenterCourseFee;
  final String? description;
  final int? quantity;
  final CourseFeeType? courseType;
  final FeeType? feeType;
  final List<FeeConfig>? feeConfigs;

  CourseFee({
    required this.id,
    required this.name,
    required this.fee,
    required this.isDefault,
    required this.isDaily,
    required this.isCenterCourseFee,
    this.description,
    this.quantity,
    this.courseType,
    this.feeType,
    this.feeConfigs,
  });

  factory CourseFee.fromJson(Map<String, dynamic> json) {
    CourseFeeType? courseTypeObj;
    if (json['courseType'] != null) {
      courseTypeObj = CourseFeeType.fromJson(json['courseType'] as Map<String, dynamic>);
    }

    FeeType? feeTypeObj;
    if (json['feeType'] != null) {
      feeTypeObj = FeeType.fromJson(json['feeType'] as Map<String, dynamic>);
    }

    List<FeeConfig>? feeConfigsList;
    if (json['feeConfigs'] != null) {
      feeConfigsList = (json['feeConfigs'] as List<dynamic>)
          .map((item) => FeeConfig.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return CourseFee(
      id: json['_id'] as String,
      name: json['name'] as String,
      fee: json['fee'] as int,
      isDefault: json['isDefault'] as bool? ?? false,
      isDaily: json['isDaily'] as bool? ?? false,
      isCenterCourseFee: json['isCenterCourseFee'] as bool? ?? true,
      description: json['description'] as String?,
      quantity: json['quantity'] as int?,
      courseType: courseTypeObj,
      feeType: feeTypeObj,
      feeConfigs: feeConfigsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'fee': fee,
      'isDefault': isDefault,
      'isDaily': isDaily,
      'isCenterCourseFee': isCenterCourseFee,
      'description': description,
      'quantity': quantity,
      'courseType': courseType?.toJson(),
      'feeType': feeType?.toJson(),
      'feeConfigs': feeConfigs?.map((e) => e.toJson()).toList(),
    };
  }

  // Format số tiền
  String get formattedFee {
    return _formatCurrency(fee);
  }

  String _formatCurrency(int amount) {
    final amountStr = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < amountStr.length; i++) {
      if (i > 0 && (amountStr.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(amountStr[i]);
    }
    return '${buffer.toString()} đ';
  }
}

class CourseFeeType {
  final String id;
  final String title;

  CourseFeeType({
    required this.id,
    required this.title,
  });

  factory CourseFeeType.fromJson(Map<String, dynamic> json) {
    return CourseFeeType(
      id: json['_id'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
    };
  }
}

class FeeType {
  final String id;
  final String title;
  final bool official;
  final bool isExtra;

  FeeType({
    required this.id,
    required this.title,
    required this.official,
    required this.isExtra,
  });

  factory FeeType.fromJson(Map<String, dynamic> json) {
    return FeeType(
      id: json['_id'] as String,
      title: json['title'] as String,
      official: json['official'] as bool? ?? false,
      isExtra: json['isExtra'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'official': official,
      'isExtra': isExtra,
    };
  }
}

class FeeConfig {
  final String id;
  final String title;
  final int fee;
  final String type;

  FeeConfig({
    required this.id,
    required this.title,
    required this.fee,
    required this.type,
  });

  factory FeeConfig.fromJson(Map<String, dynamic> json) {
    return FeeConfig(
      id: json['_id'] as String,
      title: json['title'] as String,
      fee: json['fee'] as int,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'fee': fee,
      'type': type,
    };
  }
}

class CourseFeeResponse {
  final List<CourseFee> list;
  final String? error;

  CourseFeeResponse({
    required this.list,
    this.error,
  });

  factory CourseFeeResponse.fromJson(Map<String, dynamic> json) {
    return CourseFeeResponse(
      list: (json['list'] as List<dynamic>?)
              ?.map((item) => CourseFee.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      error: json['error'] as String?,
    );
  }
}

