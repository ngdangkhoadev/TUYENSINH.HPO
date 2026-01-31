import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://lms.hpo.edu.vn';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _accessTokenExpiresInKey = 'access_token_expires_in';
  static const String _refreshTokenExpiresInKey = 'refresh_token_expires_in';
  static const String _userInfoKey = 'user_info';

  // Lấy access token từ storage
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Lấy refresh token từ storage
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Lưu tokens và expiresIn
  Future<void> saveTokens(
    String accessToken,
    String refreshToken, {
    int? accessTokenExpiresIn,
    int? refreshTokenExpiresIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    
    if (accessTokenExpiresIn != null) {
      await prefs.setInt(_accessTokenExpiresInKey, accessTokenExpiresIn);
    }
    
    if (refreshTokenExpiresIn != null) {
      await prefs.setInt(_refreshTokenExpiresInKey, refreshTokenExpiresIn);
    }
  }

  // Lấy accessTokenExpiresIn
  Future<int?> getAccessTokenExpiresIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_accessTokenExpiresInKey);
  }

  // Lấy refreshTokenExpiresIn
  Future<int?> getRefreshTokenExpiresIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_refreshTokenExpiresInKey);
  }

  // Lưu thông tin user
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userInfoKey, json.encode(userInfo));
  }

  // Lấy thông tin user
  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString(_userInfoKey);
    if (userInfoJson != null) {
      try {
        return json.decode(userInfoJson) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Xóa tokens và user info
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_accessTokenExpiresInKey);
    await prefs.remove(_refreshTokenExpiresInKey);
    await prefs.remove(_userInfoKey);
  }

  // Tạo headers với token
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = <String, String>{
      'accept': 'application/json, text/plain, */*',
      'accept-language': 'en-US,en;q=0.9,fr-FR;q=0.8,fr;q=0.7,vi;q=0.6',
      'content-type': 'application/json',
      'origin': 'https://gateway.hpo.edu.vn',
      'referer': 'https://gateway.hpo.edu.vn/',
      'user-agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36',
    };

    if (includeAuth) {
      final token = await getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    bool includeAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );

      final headers = await _getHeaders(includeAuth: includeAuth);
      final response = await http.get(uri, headers: headers);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Lỗi kết nối: ${e.toString()}',
      );
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
    bool isFormUrlEncoded = false,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );
      final headers = await _getHeaders(includeAuth: includeAuth);

      // Nếu là form-urlencoded, thay đổi content-type
      if (isFormUrlEncoded) {
        headers['content-type'] = 'application/x-www-form-urlencoded; charset=UTF-8';
        headers['X-Requested-With'] = 'XMLHttpRequest';
      }

      String? requestBody;
      if (body != null) {
        if (isFormUrlEncoded) {
          // Convert Map to form-urlencoded string
          requestBody = body.entries
              .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
              .join('&');
        } else {
          requestBody = json.encode(body);
        }
      }

      final response = await http.post(
        uri,
        headers: headers,
        body: requestBody,
      );

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Lỗi kết nối: ${e.toString()}',
      );
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http.put(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Lỗi kết nối: ${e.toString()}',
      );
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http.delete(uri, headers: headers);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Lỗi kết nối: ${e.toString()}',
      );
    }
  }

  // Xử lý response
  ApiResponse<T> _handleResponse<T>(http.Response response) {
    try {
      final statusCode = response.statusCode;
      final body = response.body;

      if (statusCode >= 200 && statusCode < 300) {
        // Parse JSON nếu có body
        if (body.isNotEmpty) {
          try {
            final data = json.decode(body) as dynamic;
            
            // Kiểm tra nếu có error trong response (trường hợp API trả về 200 nhưng có error)
            if (data is Map && data.containsKey('error')) {
              final errorObj = data['error'];
              
              // Chỉ coi là lỗi nếu error không phải null
              if (errorObj != null) {
                String errorMessage = 'Lỗi không xác định';
                
                if (errorObj is Map && errorObj.containsKey('message')) {
                  errorMessage = errorObj['message'].toString();
                } else if (errorObj is String) {
                  errorMessage = errorObj;
                }
                
                return ApiResponse<T>(
                  success: false,
                  message: errorMessage,
                  statusCode: statusCode,
                );
              }
            }
            
            return ApiResponse<T>(
              success: true,
              data: data as T?,
              statusCode: statusCode,
            );
          } catch (e) {
            // Nếu không parse được JSON, trả về body dạng string
            return ApiResponse<T>(
              success: true,
              data: body as T?,
              statusCode: statusCode,
            );
          }
        } else {
          return ApiResponse<T>(
            success: true,
            statusCode: statusCode,
          );
        }
      } else {
        // Parse error message
        String errorMessage = 'Lỗi không xác định';
        try {
          if (body.isNotEmpty) {
            final errorData = json.decode(body);
            
            // Xử lý format: { "error": { "message": "..." } }
            if (errorData is Map && errorData.containsKey('error')) {
              final errorObj = errorData['error'];
              if (errorObj is Map && errorObj.containsKey('message')) {
                errorMessage = errorObj['message'].toString();
              } else if (errorObj is String) {
                errorMessage = errorObj;
              }
            } 
            // Xử lý format: { "message": "..." }
            else if (errorData is Map && errorData.containsKey('message')) {
              errorMessage = errorData['message'].toString();
            } 
            // Xử lý format: { "error": "..." }
            else if (errorData is Map && errorData.containsKey('error')) {
              errorMessage = errorData['error'].toString();
            }
          }
        } catch (e) {
          errorMessage = 'Lỗi ${statusCode}: ${response.reasonPhrase ?? 'Unknown'}';
        }

        return ApiResponse<T>(
          success: false,
          message: errorMessage,
          statusCode: statusCode,
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Lỗi xử lý response: ${e.toString()}',
      );
    }
  }
}

// Response model
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });
}

