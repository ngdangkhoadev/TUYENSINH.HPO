class Discount {
  final String id;
  final String name;
  final int fee;
  final bool isDefault;
  final bool isActive;
  final bool isPaymentCourseFeeAtOnce;
  final String? description;
  final List<String>? courseTypes;
  final DiscountDivision? division;

  Discount({
    required this.id,
    required this.name,
    required this.fee,
    required this.isDefault,
    required this.isActive,
    required this.isPaymentCourseFeeAtOnce,
    this.description,
    this.courseTypes,
    this.division,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    DiscountDivision? divisionObj;
    if (json['division'] != null) {
      divisionObj = DiscountDivision.fromJson(json['division'] as Map<String, dynamic>);
    }

    List<String>? courseTypesList;
    if (json['courseTypes'] != null) {
      courseTypesList = (json['courseTypes'] as List<dynamic>)
          .map((item) => item.toString())
          .toList();
    }

    return Discount(
      id: json['_id'] as String,
      name: json['name'] as String,
      fee: json['fee'] as int,
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      isPaymentCourseFeeAtOnce: json['isPaymentCourseFeeAtOnce'] as bool? ?? false,
      description: json['description'] as String?,
      courseTypes: courseTypesList,
      division: divisionObj,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'fee': fee,
      'isDefault': isDefault,
      'isActive': isActive,
      'isPaymentCourseFeeAtOnce': isPaymentCourseFeeAtOnce,
      'description': description,
      'courseTypes': courseTypes,
      'division': division?.toJson(),
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

class DiscountDivision {
  final String id;
  final String title;

  DiscountDivision({
    required this.id,
    required this.title,
  });

  factory DiscountDivision.fromJson(Map<String, dynamic> json) {
    return DiscountDivision(
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

class DiscountResponse {
  final List<Discount> list;
  final String? error;

  DiscountResponse({
    required this.list,
    this.error,
  });

  factory DiscountResponse.fromJson(Map<String, dynamic> json) {
    return DiscountResponse(
      list: (json['list'] as List<dynamic>?)
              ?.map((item) => Discount.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      error: json['error'] as String?,
    );
  }
}


