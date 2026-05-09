import 'dart:convert';
import 'package:bitebox/services/storage_service.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  //base url
  static const String _baseUrl = 'http://192.168.1.1:3000';

  //call the storage services
  final StorageService _service = StorageService();

  //for the lazy authentication
  //signin -> cmsid -> return Jwt

  Future<Map<String, dynamic>> studentLogin({
    required String cmsId,
    required String name,
    required String phone,
    required String category,
    required String paymentMethod,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/Student/auth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cms_id': cmsId,
          'name': name,
          'phone': phone,
          'category': category,
          'payment_method': paymentMethod,
        }),
      );

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
        return {
          'success': false,
          'message': error['message'] ?? 'Login Failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  //restaurant side authentication
  //POST /auth/staff/login
  Future<Map<String, dynamic>> staffLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/staff/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _service.saveToken(data['token'] as String);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? "invalid Email or password",
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  //logout
  Future<void> logout() async {
    await _service.clearAll();
  }

  //forgot password
  //email send to the backend and it resend the OTP
  Future<Map<String, dynamic>> forgotpassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgotpassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Email not found!',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
  // VERIFY OTP
  // POST /auth/verify-otp
  // sends email + otp → backend verifies → returns reset token

  Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'OTP': otp}),
      );

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

  // RESET PASSWORD
  // POST /auth/reset-password
  // sends reset_token + new password → backend updates hash

Future <Map<String,dynamic>> resetpassword({
   required String resetToken,
    required String newPassword,
}) async{
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reset_token': resetToken,
          'new_password': newPassword,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Reset failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
