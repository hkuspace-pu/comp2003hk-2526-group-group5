import 'package:flutter/material.dart';

class SignUpData extends ChangeNotifier {
  bool _privacyPolicyAccepted;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  SignUpData()
      : _privacyPolicyAccepted = false,
        userNameController = TextEditingController(),
        emailController = TextEditingController(),
        passwordController = TextEditingController(),
        confirmPasswordController = TextEditingController();

  bool get privacyPolicyAccepted => _privacyPolicyAccepted;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  set privacyPolicyAccepted(bool value) {
    if (_privacyPolicyAccepted != value) {
      _privacyPolicyAccepted = value;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
