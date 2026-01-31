import 'dart:convert';
import '../services/api_service.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Đăng nhập
  Future<AuthResponse> login(String username, String password) async {
    final response = await _apiService.post<dynamic>(
      '/login',
      body: {
        'username': username,
        'password': password,
      },
      includeAuth: false,
    );

    // Kiểm tra nếu response không thành công hoặc có error
    if (!response.success) {
      return AuthResponse(
        success: false,
        message: response.message ?? 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
      );
    }

    // Xử lý response - có thể là Map hoặc String
    Map<String, dynamic>? data;
    if (response.data is Map) {
      data = response.data as Map<String, dynamic>;
    } else if (response.data is String) {
      try {
        data = json.decode(response.data as String) as Map<String, dynamic>;
      } catch (e) {
        // Nếu không parse được, trả về lỗi
        return AuthResponse(
          success: false,
          message: 'Lỗi xử lý dữ liệu từ server',
        );
      }
    } else {
      return AuthResponse(
        success: false,
        message: 'Dữ liệu phản hồi không hợp lệ',
      );
    }

    // Kiểm tra nếu có error trong data (trường hợp API trả về 200 nhưng có error object)
    if (data.containsKey('error')) {
      final errorObj = data['error'];
      String errorMessage = 'Đăng nhập thất bại';
      
      if (errorObj is Map && errorObj.containsKey('message')) {
        errorMessage = errorObj['message'].toString();
      } else if (errorObj is String) {
        errorMessage = errorObj;
      }
      
      return AuthResponse(
        success: false,
        message: errorMessage,
      );
    }
    
    // Lưu tokens nếu có trong data
    final accessToken = data['accessToken'] ?? 
                        data['access-token'] ?? 
                        data['access_token'] ??
                        data['token'];
    final refreshToken = data['refreshToken'] ?? 
                          data['refresh-token'] ?? 
                          data['refresh_token'];
    final accessTokenExpiresIn = data['accessTokenExpiresIn'] ?? 
                                  data['access_token_expires_in'];
    final refreshTokenExpiresIn = data['refreshTokenExpiresIn'] ?? 
                                   data['refresh_token_expires_in'];
    
    // Kiểm tra nếu không có token thì đăng nhập thất bại
    if (accessToken == null || accessToken.isEmpty) {
      return AuthResponse(
        success: false,
        message: 'Đăng nhập thất bại. Không nhận được token từ server.',
      );
    }
    
    // Lưu thông tin user nếu có
    UserModel? user;
    if (data['user'] != null && data['user'] is Map) {
      final userData = data['user'] as Map<String, dynamic>;
      user = UserModel.fromJson(userData);
      await _apiService.saveUserInfo(userData);
    }
    
    // Lưu tokens
    await _apiService.saveTokens(
      accessToken, 
      refreshToken?.isNotEmpty == true ? refreshToken! : '',
      accessTokenExpiresIn: accessTokenExpiresIn is int ? accessTokenExpiresIn : null,
      refreshTokenExpiresIn: refreshTokenExpiresIn is int ? refreshTokenExpiresIn : null,
    );

    return AuthResponse(
      success: true,
      message: 'Đăng nhập thành công',
      data: data,
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  // Đăng xuất
  Future<bool> logout() async {
    try {
      final refreshToken = await _apiService.getRefreshToken();
      
      // Gọi API logout nếu có refreshToken
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final response = await _apiService.post<dynamic>(
          '/logout',
          queryParameters: {'t': timestamp.toString()},
          body: {'refreshToken': refreshToken},
          includeAuth: true,
          isFormUrlEncoded: true,
        );

        // Xóa tokens dù API có thành công hay không
        await _apiService.clearTokens();
        
        return response.success;
      } else {
        // Nếu không có refreshToken, chỉ xóa tokens local
        await _apiService.clearTokens();
        return true;
      }
    } catch (e) {
      // Nếu có lỗi, vẫn xóa tokens local
      await _apiService.clearTokens();
      return false;
    }
  }

  // Kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Lấy thông tin user đã lưu
  Future<UserModel?> getSavedUser() async {
    final userInfo = await _apiService.getUserInfo();
    if (userInfo != null) {
      return UserModel.fromJson(userInfo);
    }
    return null;
  }
}

