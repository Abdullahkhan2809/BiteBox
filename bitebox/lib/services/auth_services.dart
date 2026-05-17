import 'dart:convert';
import 'package:bitebox/core/constant.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static const String _baseUrl = AppConstants.baseUrl;
  static const Duration _timeout = AppConstants.requestTimeout;

  final StorageService _service = StorageService();

  Future<Map<String, dynamic>> studentLogin({
    required String cmsId,
    required String name,
    required String phone,
    required String category,
    required String paymentMethod,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/student'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cms_id': cmsId}),
      ).timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        await _service.saveToken(token);
        await _service.saveStudent(
          cmsId: cmsId,
          name: name,
          phone: phone,
          category: category,
          paymentMethod: paymentMethod,
        );
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Login Failed'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> staffLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/staff/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _service.saveToken(data['token'] as String);
        await _service.saveStaffSession(
          role: data['role'] as String? ?? 'staff',
          restaurantId: data['restaurant_id']?.toString(),
        );
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Invalid Email or password'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> logout() async {
    await _service.clearAll();
  }

  Future<Map<String, dynamic>> forgotpassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Email not found!'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'reset_token': data['reset_token']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Invalid OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> resetpassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'reset_token': resetToken, 'new_password': newPassword}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Reset failed'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}