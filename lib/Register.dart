import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

// Firebase core packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Login.dart';
import 'screens/user/privacy_policy_screen.dart';
import 'screens/main/main_shell_screen.dart';

class SignUpData extends ChangeNotifier {
  bool _privacyPolicyAccepted;
  // Loading state to prevent multiple submissions
  bool _isLoading = false;

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

  // Getter for loading state
  bool get isLoading => _isLoading;

  set privacyPolicyAccepted(bool value) {
    if (_privacyPolicyAccepted != value) {
      _privacyPolicyAccepted = value;
      notifyListeners();
    }
  }

  // Method to update loading state
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
    super.dispose();
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  // Simple email format validation
  bool _looksLikeEmail(String value) {
    final String v = value.trim();
    return v.contains('@') && v.contains('.');
  }

  // Firebase Sign-Up Logic
  Future<void> _handleSignUp(BuildContext context, SignUpData signUpData) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    // Check if privacy policy is accepted
    if (!signUpData.privacyPolicyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgAcceptPrivacy)),
      );
      return;
    }

    final String userName = signUpData.userNameController.text.trim();
    final String email = signUpData.emailController.text.trim();
    final String password = signUpData.passwordController.text;
    final String confirmPassword = signUpData.confirmPasswordController.text;

    // Basic form validation
    if (userName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgFillAllFields)),
      );
      return;
    }
    if (!_looksLikeEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgEnterValidEmail)),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgPasswordMismatch)),
      );
      return;
    }

    // Start loading state
    signUpData.setLoading(true);

    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Store additional user data (username) in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': userName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'cityLevel': 1,
      });

      if (!context.mounted) return;

      // Navigate to main screen on success
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const MainShellScreen()),
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration Error")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      // Stop loading state
      signUpData.setLoading(false);
    }
  }

  // Reusable decoration to match Image 2
  InputDecoration _getInputDecoration(String hintText, AppLocalizations l10n, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3CB371), width: 2),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Consumer<SignUpData>(
            builder: (BuildContext context, SignUpData signUpData, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: Colors.black87,
                  ),
                  Text(
                    l10n.signUp,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Restore Hint Text from Image 2
                  Text(
                    l10n.authContinueHint,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Username Field
                  Text(l10n.userNameLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: signUpData.userNameController,
                    decoration: _getInputDecoration(l10n.enterUserNameHint, l10n),
                  ),
                  const SizedBox(height: 24),

                  // Email Field
                  Text(l10n.emailLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: signUpData.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _getInputDecoration(l10n.enterEmailHint, l10n),
                  ),
                  const SizedBox(height: 24),

                  // Password Field
                  Text(l10n.passwordLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: signUpData.passwordController,
                    obscureText: !signUpData.isPasswordVisible,
                    decoration: _getInputDecoration(
                      l10n.enterPasswordHint,
                      l10n,
                      suffixIcon: IconButton(
                        icon: Icon(
                          signUpData.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey[400],
                        ),
                        onPressed: signUpData.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Password Field
                  Text(l10n.confirmPasswordLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: signUpData.confirmPasswordController,
                    obscureText: !signUpData.isConfirmPasswordVisible,
                    decoration: _getInputDecoration(
                      l10n.confirmPasswordHint,
                      l10n,
                      suffixIcon: IconButton(
                        icon: Icon(
                          signUpData.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey[400],
                        ),
                        onPressed: signUpData.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Privacy Policy Checkbox and "Read full policy" link
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: signUpData.privacyPolicyAccepted,
                        onChanged: (val) => signUpData.privacyPolicyAccepted = val ?? false,
                        activeColor: const Color(0xFF3CB371),
                        side: BorderSide(color: Colors.grey[400]!, width: 2),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                l10n.agreePrivacyPolicy,
                                style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyScreen()),
                                );
                              },
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                              child: Text(
                                l10n.readFullPolicy,
                                style: const TextStyle(color: Color(0xFF46AA57), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: signUpData.isLoading
                          ? null
                          : () => _handleSignUp(context, signUpData),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF46AA57),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: signUpData.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        l10n.signUp,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}