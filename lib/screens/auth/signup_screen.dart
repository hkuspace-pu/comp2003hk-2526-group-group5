import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';

class SignUpData extends ChangeNotifier {
  bool _isAgreed = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController invitationCodeController = TextEditingController();

  bool get isAgreed => _isAgreed;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isLoading => _isLoading;

  void setAgreed(bool value) {
    _isAgreed = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
    invitationCodeController.dispose();
    super.dispose();
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  static final RegExp _emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  Future<void> _handleSignUp(BuildContext context, SignUpData data) async {
    final String name = data.userNameController.text.trim();
    final String email = data.emailController.text.trim();
    final String password = data.passwordController.text;
    final String confirmPassword = data.confirmPasswordController.text;
    final String inviteCode = data.invitationCodeController.text.trim();

    // Validation logic
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError(context, 'Please fill in all required fields');
      return;
    }
    if (!_emailRegExp.hasMatch(email)) {
      _showError(context, 'Invalid email address format');
      return;
    }
    if (!_passwordRegExp.hasMatch(password)) {
      _showError(context, 'Password must be 8+ chars with letters, numbers, and symbols');
      return;
    }
    if (password != confirmPassword) {
      _showError(context, 'Passwords do not match!');
      return;
    }
    if (!data.isAgreed) {
      _showError(context, 'Please agree to the privacy policy');
      return;
    }

    data.setLoading(true);
    try {
      // Firebase Auth Creation
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save to Firestore using original Service logic
      await _firestoreService.saveUserInitialData(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        invitationCode: inviteCode.isEmpty ? null : inviteCode,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      // Navigate to Login
      Navigator.pushReplacementNamed(context, '/login');

    } on FirebaseAuthException catch (e) {
      _showError(context, e.message ?? 'An error occurred during sign up');
    } catch (e) {
      _showError(context, 'Critical error: $e');
    } finally {
      if (mounted) data.setLoading(false);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpData(),
      child: Consumer<SignUpData>(
        builder: (context, signUpData, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F8EC), // Original cream color
            body: SafeArea(
              child: signUpData.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF46AA57)))
                  : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sign Up',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text('Join the Focus City community today',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 32),

                    _buildLabel('User Name'),
                    _buildTextField(signUpData.userNameController, 'Enter your name', false),

                    _buildLabel('Email'),
                    _buildTextField(signUpData.emailController, 'Enter your email', false,
                        keyboardType: TextInputType.emailAddress),

                    _buildLabel('Password'),
                    _buildTextField(
                      signUpData.passwordController,
                      'Enter password',
                      !signUpData.isPasswordVisible,
                      isPassword: true,
                      onToggle: signUpData.togglePasswordVisibility,
                      isVisible: signUpData.isPasswordVisible,
                    ),

                    _buildLabel('Confirm Password'),
                    _buildTextField(
                      signUpData.confirmPasswordController,
                      'Confirm password',
                      !signUpData.isConfirmPasswordVisible,
                      isPassword: true,
                      onToggle: signUpData.toggleConfirmPasswordVisibility,
                      isVisible: signUpData.isConfirmPasswordVisible,
                    ),

                    _buildLabel('Invitation or Family Group Code (Optional)'),
                    _buildTextField(
                      signUpData.invitationCodeController,
                      '',             // Remove the hint text here for security
                      true,
                      keyboardType: TextInputType.text,
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: signUpData.isAgreed,
                          activeColor: const Color(0xFF46AA57),
                          onChanged: (val) => signUpData.setAgreed(val ?? false),
                        ),
                        const Expanded(
                          child: Text('I agree to the Privacy Policy and Terms'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => _handleSignUp(context, signUpData),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF46AA57),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Already have an account? Login',
                            style: TextStyle(color: Color(0xFF46AA57))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool obscure,
      {bool isPassword = false, VoidCallback? onToggle, bool? isVisible, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword && onToggle != null
            ? IconButton(
          icon: Icon((isVisible ?? false) ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF46AA57), width: 1.5),
        ),
      ),
    );
  }
}