import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'Login.dart';
import 'screens/user/privacy_policy_screen.dart';
import 'screens/main/main_shell_screen.dart';

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

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  bool _looksLikeEmail(String value) {
    final String v = value.trim();
    return v.contains('@') && v.contains('.');
  }

  void _handleSignUp(BuildContext context, SignUpData signUpData) {
    if (!signUpData.privacyPolicyAccepted) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.msgAcceptPrivacy),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final String userName = signUpData.userNameController.text.trim();
    final String email = signUpData.emailController.text.trim();
    final String password = signUpData.passwordController.text;
    final String confirmPassword = signUpData.confirmPasswordController.text;

    if (userName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.msgFillAllFields)),
      );
      return;
    }
    if (!_looksLikeEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.msgEnterValidEmail)),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.msgPasswordMismatch),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MainShellScreen(),
      ),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: Colors.black87,
                    ),
                  ),
                  // Title
                  Text(
                    l10n.signUp,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    l10n.authContinueHint,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // User Name field
                  Text(l10n.userNameLabel,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: signUpData.userNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: l10n.enterUserNameHint,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
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
                        borderSide:
                        const BorderSide(color: Color(0xFF3CB371), width: 2),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email field
                  Text(l10n.emailLabel,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: signUpData.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: l10n.enterEmailHint,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
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
                        borderSide:
                        const BorderSide(color: Color(0xFF3CB371), width: 2),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Password field
                  Text(l10n.passwordLabel,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: signUpData.passwordController,
                    obscureText: !signUpData.isPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: l10n.enterPasswordHint,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
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
                        borderSide:
                        const BorderSide(color: Color(0xFF3CB371), width: 2),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          signUpData.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey[400],
                        ),
                        onPressed: signUpData.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Password field
                  Text(l10n.confirmPasswordLabel,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: signUpData.confirmPasswordController,
                    obscureText: !signUpData.isConfirmPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: l10n.confirmPasswordHint,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
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
                        borderSide:
                        const BorderSide(color: Color(0xFF3CB371), width: 2),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          signUpData.isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey[400],
                        ),
                        onPressed: signUpData.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Privacy policy (UI only)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: signUpData.privacyPolicyAccepted,
                        onChanged: (bool? value) {
                          if (value != null) {
                            signUpData.privacyPolicyAccepted = value;
                          }
                        },
                        activeColor: const Color(0xFF3CB371),
                        checkColor: Colors.white,
                        side: WidgetStateBorderSide.resolveWith(
                          (Set<WidgetState> states) =>
                              BorderSide(color: Colors.grey[400]!, width: 2),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                signUpData.privacyPolicyAccepted =
                                    !signUpData.privacyPolicyAccepted;
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  l10n.agreePrivacyPolicy,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                l10n.readFullPolicy,
                                style: TextStyle(
                                  color: Color(0xFF46AA57),
                                  fontWeight: FontWeight.w600,
                                ),
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
                      onPressed: () => _handleSignUp(context, signUpData),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF46AA57),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        l10n.signUp,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Login footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        l10n.haveAccountPrompt,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.loginButton,
                          style: TextStyle(
                            color: Color(0xFF3CB371),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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