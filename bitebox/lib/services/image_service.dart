import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bitebox/core/constant.dart';
import 'package:bitebox/services/storage_service.dart';

class ImageService {
  static const String _baseUrl = AppConstants.baseUrl;
  final StorageService _storage = StorageService();
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery or camera
  Future<XFile?> pickImage({bool fromCamera = false}) async {
    return await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
  }

  /// Upload picked image to backend → Cloudinary
  Future<Map<String, dynamic>> uploadImage(XFile file) async {
    try {
      final token = _storage.getTokens();
      final uri = Uri.parse('$_baseUrl/upload');
      final bytes = await file.readAsBytes();

      final ext = file.name.split('.').last.toLowerCase();
      final mimeSubtype = ext == 'png' ? 'png' : 'jpeg';

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(http.MultipartFile.fromBytes(
          'image', bytes,
          filename: file.name,
          contentType: MediaType('image', mimeSubtype),
        ));

      final response = await request.send();
      final body = json.decode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        return {'success': true, 'image_url': body['image_url']};
      }
      return {'success': false, 'message': body['message'] ?? 'Upload failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}