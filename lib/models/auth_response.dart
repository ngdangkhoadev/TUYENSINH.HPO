import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;

  AuthResponse({
    required this.success,
    this.message,
    this.data,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
      accessToken: json['accessToken'] ?? json['access-token'],
      refreshToken: json['refreshToken'] ?? json['refresh-token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}

