import 'package:bitebox/models/student_model.dart';
import 'package:bitebox/services/auth_services.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthServices _authservices = AuthServices();
  final StorageService _storage = StorageService();

  StudentModel? _student;
  String? _token;
  String? _role; //student/staff
  String? _restaurantid;
  bool _isloading = false;
  String? _errorMsg;

  //getter
  StudentModel? get student => _student;
  String? get token => _token;
  String? get role => _role;
  String? get restaurantId => _restaurantid;
  bool get isLoading => _isloading;
  String? get errorMessage => _errorMsg;
  bool get isLoggedIn => _token != null;
  bool get isStudent => _role == 'student';
  bool get isStaff => _role == 'staff' || _role == 'cafe_manager';

  //loads the session of the app when started
  // calls main.dart
  void loadSession() {
    _token = _storage.getTokens();
    if (_token == null) {
      notifyListeners();
      return;
    }

    final savedRole = _storage.getRole();

    if (savedRole == 'staff' || savedRole == 'cafe_manager') {
      _role         = savedRole;
      _restaurantid = _storage.getRestaurantId();
    } else {
      final cmsId        = _storage.getStudentCMSID();
      final name         = _storage.getStudentName();
      final phone        = _storage.getStudentPhone();
      final paymentMethod = _storage.getStudentPaymentMethod();

      if (cmsId != null && name != null && phone != null) {
        _student = StudentModel(
          cmsid: cmsId,
          name: name,
          phone: phone,
          category: 'student',
          paymentMethod: paymentMethod ?? 'cash',
        );
        _role = 'student';
      }
    }
    notifyListeners();
  }

  //lazy authentication user side
  Future<bool> Studentlogin({
    required String cmsId,
    required String name,
    required String phone,
    required String category,
    required String paymentMethod,
  }) async {
    _setLoading(true);

    final result = await _authservices.studentLogin(
      cmsId: cmsId,
      name: name,
      phone: phone,
      category: category,
      paymentMethod: paymentMethod,
    );

    if (result['success']) {
      _token = _storage.getTokens();
      _role = 'student';
      _student = StudentModel(
        cmsid: cmsId,
        name: name,
        phone: phone,
        category: category,
        paymentMethod: paymentMethod,
      );
      _errorMsg=null;
      _isloading=false;
      return true;

    }else{
      _errorMsg=result['message'];
      _setLoading(false);
      return false;
    }
  }

  //login staff
  Future<bool> staffloggin({
    required String email,
    required String password,
  }) async{
    _setLoading(true);

     final result = await _authservices.staffLogin(
      email:    email,
      password: password,
    );

    if (result['success']) {
      final data = result['data'] as Map<String, dynamic>;
      _token        = _storage.getTokens();
      _role         = data['role'] as String?;
      _restaurantid = data['restaurant_id']?.toString();
      final name = data['name'] as String?;
      if (name != null) await _storage.saveStaffName(name);
      _errorMsg = null;
      _isloading=false;
      return true;
    } else {
      _errorMsg = result['message'];
      _setLoading(false);
      return false;
    }
  }

  //logout
  Future<void> logout() async {
    await _authservices.logout();
    _token        = null;
    _role         = null;
    _student      = null;
    _restaurantid = null;
    notifyListeners();
  }

  // ── update payment method (from adduserdetails screen) ──────────────────
  Future<void> updatePaymentMethod(String method) async {
    if (_student == null) return;
    _student = StudentModel(
      cmsid: _student!.cmsid,
      name: _student!.name,
      phone: _student!.phone,
      category: _student!.category,
      paymentMethod: method,
    );
    await _storage.saveStudent(
      cmsId:         _student!.cmsid,
      name:          _student!.name,
      phone:         _student!.phone,
      category:      _student!.category,
      paymentMethod: method,
    );
    notifyListeners();
  }

  // ── update complete student details (from adduserdetails form) ──────────────────
  Future<void> updateStudentDetails({
    required String name,
    required String phone,
    required String cmsid,
    required String paymentMethod,
  }) async {
    _student = StudentModel(
      cmsid: cmsid,
      name: name,
      phone: phone,
      category: _student?.category ?? 'student',
      paymentMethod: paymentMethod,
    );

    await _storage.saveStudent(
      cmsId: cmsid,
      name: name,
      phone: phone,
      category: _student!.category,
      paymentMethod: paymentMethod,
    );

    notifyListeners();
  }

  //help
   void _setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  Future<void> loadUser() async {}
}
