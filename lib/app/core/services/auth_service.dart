import 'package:get/get.dart';
import 'storage_service.dart';

/// Authentication service for managing user authentication state
class AuthService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  
  final RxBool _isAuthenticated = false.obs;
  final Rxn<String> _userEmail = Rxn<String>();

  bool get isAuthenticated => _isAuthenticated.value;
  String? get userEmail => _userEmail.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  /// Check if user is already authenticated
  void _checkAuthStatus() {
    final email = _storageService.read<String>('user_email');
    if (email != null) {
      _userEmail.value = email;
      _isAuthenticated.value = true;
    }
  }

  /// Mock login with email validation and delay
  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock authentication logic
      if (email.isNotEmpty && password.length >= 6) {
        await _storageService.write('user_email', email);
        _userEmail.value = email;
        _isAuthenticated.value = true;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _storageService.remove('user_email');
    _userEmail.value = null;
    _isAuthenticated.value = false;
  }
}