import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';

// Handles input controllers and loading states
class LoginData extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void toggleVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final RegExp _emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginData(),
      child: Consumer<LoginData>(
        builder: (context, data, _) => Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Login Now', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  const Text('Please login or sign up to continue using our app', style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.4)),
                  const SizedBox(height: 32),
                  const Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  _buildTextField(data.emailController, 'Enter your email', false, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  const Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  _buildTextField(data.passwordController, 'Enter your password', !data.isPasswordVisible, onToggle: data.toggleVisibility, isPassword: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: data.isLoading ? null : () => _handleResetPassword(context, data),
                      child: const Text('Forgot password?', style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: data.isLoading ? null : () => _performLogin(context, data),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF46AA57),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 8,
                      ),
                      child: data.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => debugPrint('Sign in with Google'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/google_icon.png', width: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
                          const SizedBox(width: 12),
                          const Flexible(
                            child: Text('Sign in with Google', style: TextStyle(color: Colors.black87, fontSize: 16), overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/signup'),
                          child: const Text('Sign up', style: TextStyle(color: Color(0xFF46AA57), fontWeight: FontWeight.w600, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performLogin(BuildContext context, LoginData data) async {
    final String email = data.emailController.text.trim();
    final String password = data.passwordController.text.trim();

    if (!_emailRegExp.hasMatch(email)) {
      _showError(context, 'Invalid email format');
      return;
    }
    if (!_passwordRegExp.hasMatch(password)) {
      _showError(context, 'Password must be 8+ chars with letter, number, and special char');
      return;
    }

    data.setLoading(true);
    try {
      // Authenticate with Firebase
      final UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if (!context.mounted) return;

      // Fetch the detailed profile via UserProvider to check the 'role'
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshProfile(cred.user!.uid);

      if (!context.mounted) return;

      // ROLE-BASED REDIRECTION [NEW]
      if (userProvider.userProfile?.role == 'counselor') {
        Navigator.pushReplacementNamed(context, '/counselor');
      } else {
        Navigator.pushReplacementNamed(context, '/main');
      }

    } on FirebaseAuthException catch (e) {
      _showError(context, e.message ?? 'Login failed');
    } finally {
      data.setLoading(false);
    }
  }

  Future<void> _handleResetPassword(BuildContext context, LoginData data) async {
    final String email = data.emailController.text.trim();
    if (email.isEmpty) {
      _showError(context, 'Please enter email to reset password');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset email sent!')));
    } catch (e) {
      _showError(context, 'Failed to send reset email');
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, bool obscure, {bool isPassword = false, VoidCallback? onToggle, TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword ? IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: onToggle) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 1)),
      ),
    );
  }
}