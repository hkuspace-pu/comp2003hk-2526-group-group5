import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added Firestore import
import 'package:groupproject_group5/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'Register.dart';
import 'screens/user/forgot_password_screen.dart';
import 'screens/main/main_shell_screen.dart';

/// Demo credentials used for testing purposes.
const String kDemoLoginEmail = 'demo@screen-time.app';
const String kDemoLoginPassword = 'Demo1234!';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // Track if a login request is currently in progress.
  bool _isLoading = false;

  // Track password visibility status.
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Simple regex-like check for email format validation.
  bool _looksLikeEmail(String value) {
    final String v = value.trim();
    return v.contains('@') && v.contains('.');
  }

  /// Authenticate user with Firebase Email & Password and verify role.
  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // Basic UI validation before calling Firebase.
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.msgEnterEmailPassword)),
      );
      return;
    }

    if (!_looksLikeEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.msgEnterValidEmail)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Firebase Authentication Sign In.
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Retrieve user profile data from Firestore 'users' collection.
      final userDoc = await FirebaseFirestore.instance
          .collection('users') // Unified collection for all users
          .doc(userCredential.user!.uid)
          .get();

      // ========================================================
      // [Core Modification: Role Verification / Route Guard]
      // ========================================================
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;

        // Check if the role field exists and equals 'staff'.
        if (data.containsKey('role') && data['role'] == 'staff') {
          // Force sign out immediately if a staff account tries to access user client app.
          await FirebaseAuth.instance.signOut();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Access Denied: Staff accounts cannot login to the user page."),
              backgroundColor: Colors.redAccent,
            ),
          );
          return; // Abort further navigation.
        }
      } else {
        // Handle edge case where Auth account exists but Firestore record is missing.
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account Error: Profile record not found in database."),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return; // Abort further navigation.
      }
      // ========================================================

      // On success, navigate to the main application shell.
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const MainShellScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Map Firebase error codes to user-friendly messages.
      String errorMsg = "Login Failed";
      if (e.code == 'user-not-found') {
        errorMsg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Incorrect password.";
      } else if (e.code == 'invalid-credential') {
        errorMsg = "Invalid email or password.";
      } else if (e.code == 'user-disabled') {
        errorMsg = "This account has been disabled.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An unexpected error occurred.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Developer Shortcut: Auto-fills demo credentials.
  void _fillDemoAccount() {
    setState(() {
      _emailController.text = kDemoLoginEmail;
      _passwordController.text = kDemoLoginPassword;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.msgEmailPasswordFilled)),
    );
  }

  void _handleForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const ForgotPasswordScreen(),
      ),
    );
  }

  void _handleGoogleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.msgGoogleUnavailable)),
    );
  }

  void _handleSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChangeNotifierProvider<SignUpData>(
          create: (_) => SignUpData(),
          child: const SignUpScreen(),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.black87,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 32),

              // Title with hidden "Double-Tap to Fill Demo" feature.
              GestureDetector(
                onDoubleTap: _fillDemoAccount,
                child: Text(
                  l10n.loginNowTitle,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.authContinueHint,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),

              // Email Input Field
              Text(
                l10n.emailLabel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: l10n.enterEmailHint,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              const SizedBox(height: 24),

              // Password Input Field
              Text(
                l10n.passwordLabel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: l10n.enterPasswordHint,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : _handleForgotPassword,
                  child: Text(
                    l10n.forgotPassword,
                    style: TextStyle(
                      color: Colors.grey[700],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Main Login Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF46AA57),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    l10n.loginButton,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Social Sign-In (Google)
              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: Image.asset('images/google_icon.png', width: 22),
                  label: Text(l10n.signInWithGoogle),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Sign Up Navigation Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.noAccountPrompt,
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                  TextButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    child: Text(
                      l10n.signUp,
                      style: const TextStyle(
                        color: Color(0xFF46AA57),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}