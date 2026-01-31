class Division {
  final String id;
  final String title;
  final int? priority;
  final bool active;
  final String? parentType;
  final List<String>? type;
  final bool? isOutside;
  final bool? isAffiliatedSchool;
  final String? address;
  final String? email;
  final String? phoneNumber;
  final String? mobile;
  final String? mapURL;
  final String? shortDescription;
  final String? detailDescription;
  final String? image;
  final String? syntax;

  Division({
    required this.id,
    required this.title,
    this.priority,
    required this.active,
    this.parentType,
    this.type,
    this.isOutside,
    this.isAffiliatedSchool,
    this.address,
    this.email,
    this.phoneNumber,
    this.mobile,
    this.mapURL,
    this.shortDescription,
    this.detailDescription,
    this.image,
    this.syntax,
  });

  factory Division.fromJson(Map<String, dynamic> json) {
    List<String>? typeList;
    if (json['type'] != null) {
      final typeData = json['type'];
      if (typeData is List) {
        typeList = typeData.map((e) => e.toString()).toList();
      }
    }

    return Division(
      id: json['_id'] as String,
      title: json['title'] as String,
      priority: json['priority'] as int?,
      active: json['active'] as bool? ?? true,
      parentType: json['parentType'] as String?,
      type: typeList,
      isOutside: json['isOutside'] as bool?,
      isAffiliatedSchool: json['isAffiliatedSchool'] as bool?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      mobile: json['mobile'] as String?,
      mapURL: json['mapURL'] as String?,
      shortDescription: json['shortDescription'] as String?,
      detailDescription: json['detailDescription'] as String?,
      image: json['image'] as String?,
      syntax: json['syntax'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'priority': priority,
      'active': active,
      'parentType': parentType,
      'type': type,
      'isOutside': isOutside,
      'isAffiliatedSchool': isAffiliatedSchool,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'mobile': mobile,
      'mapURL': mapURL,
      'shortDescription': shortDescription,
      'detailDescription': detailDescription,
      'image': image,
      'syntax': syntax,
    };
  }
}

class DivisionResponse {
  final List<Division> list;
  final String? error;

  DivisionResponse({
    required this.list,
    this.error,
  });

  factory DivisionResponse.fromJson(Map<String, dynamic> json) {
    // Lấy tất cả divisions: cả item chính và dependencyDivisions từ tất cả items trong list
    final Map<String, Division> divisionsMap = {};
    
    if (json['list'] != null) {
      final listItems = json['list'] as List<dynamic>;
      
      for (final item in listItems) {
        final itemMap = item as Map<String, dynamic>;
        
        // Lấy item chính nếu có type (có thể là coSoDaoTao hoặc vanPhongTuyenSinh)
        if (itemMap['type'] != null) {
          final division = Division.fromJson(itemMap);
          divisionsMap[division.id] = division;
        }
        
        // Lấy dependencyDivisions từ mỗi item
        if (itemMap['dependencyDivisions'] != null) {
          final dependencyDivisions = itemMap['dependencyDivisions'] as List<dynamic>;
          
          for (final div in dependencyDivisions) {
            final divMap = div as Map<String, dynamic>;
            final division = Division.fromJson(divMap);
            // Sử dụng Map để loại bỏ duplicate dựa trên id
            divisionsMap[division.id] = division;
          }
        }
      }
    }

    return DivisionResponse(
      list: divisionsMap.values.toList(),
      error: json['error'] as String?,
    );
  }
}

