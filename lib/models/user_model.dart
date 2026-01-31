class UserModel {
  final String id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? username;
  final String? phoneNumber;
  final Map<String, dynamic>? division;
  final List<String>? permissions;
  final Map<String, dynamic>? menu;

  UserModel({
    required this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.phoneNumber,
    this.division,
    this.permissions,
    this.menu,
  });

  String get fullName {
    final parts = <String>[];
    if (firstname != null && firstname!.isNotEmpty) {
      parts.add(firstname!);
    }
    if (lastname != null && lastname!.isNotEmpty) {
      parts.add(lastname!);
    }
    return parts.isEmpty ? (username ?? 'Người dùng') : parts.join(' ');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      division: json['division'] is Map ? json['division'] as Map<String, dynamic> : null,
      permissions: json['permissions'] is List ? List<String>.from(json['permissions']) : null,
      menu: json['menu'] is Map ? json['menu'] as Map<String, dynamic> : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'division': division,
      'permissions': permissions,
      'menu': menu,
    };
  }
}

