import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';

/// Controller for login functionality using GetX
class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Observable variables
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  
  // Email validation regex
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void onInit() {
    super.onInit();
    
    // Listen to text field changes
    emailController.addListener(() {
      email.value = emailController.text;
      validateEmail();
    });
    
    passwordController.addListener(() {
      password.value = passwordController.text;
      validatePassword();
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Validate email field
  void validateEmail() {
    if (email.value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!emailRegex.hasMatch(email.value)) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }

  /// Validate password field
  void validatePassword() {
    if (password.value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (password.value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
  }

  /// Check if form is valid
  bool get isFormValid {
    return emailError.value.isEmpty && 
           passwordError.value.isEmpty && 
           email.value.isNotEmpty && 
           password.value.isNotEmpty;
  }

  /// Handle login process
  Future<void> login() async {
    if (!isFormValid) {
      validateEmail();
      validatePassword();
      return;
    }

    try {
      isLoading.value = true;
      
      final success = await _authService.login(email.value, password.value);
      
      if (success) {
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to dashboard and clear navigation stack
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        Get.snackbar(
          'Error',
          'Invalid email or password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during login',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear form fields
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    emailError.value = '';
    passwordError.value = '';
  }
}