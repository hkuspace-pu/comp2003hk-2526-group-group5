import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'staff_shell_screen.dart';
import 'staff_signup_screen.dart';
import 'staff_theme.dart';

/// Credentials used for developer testing shortcut.
const String kStaffDemoLoginEmail = 'staff@screen-time.app';
const String kStaffDemoLoginPassword = 'Staff1234!';

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // Track if an authentication request is in progress.
  bool _isLoading = false;

  // Track whether the password text should be hidden or visible.
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

  /// Simple helper to validate basic email format.
  bool _looksLikeEmail(String value) {
    final String v = value.trim();
    return v.contains('@') && v.contains('.');
  }

  /// Handles the Firebase login process.
  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // Validate empty fields.
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgEnterWorkEmailPassword)),
      );
      return;
    }

    // Validate email format.
    if (!_looksLikeEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgEnterValidEmail)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Sign in with Firebase Auth.
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // 2. Retrieve user profile data from Firestore.
      String displayName = 'Staff';
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        if (data.containsKey('username')) {
          displayName = data['username'];
        }
      }

      if (!mounted) return;

      // 3. Navigate to the staff dashboard.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => StaffShellScreen(
            staffDisplayName: displayName,
            staffEmail: email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      // Provide user feedback for common auth failures.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication Failed")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Developer Shortcut: Fills the demo account and logs in automatically.
  void _signInWithDemoAccount() {
    setState(() {
      _emailController.text = kStaffDemoLoginEmail;
      _passwordController.text = kStaffDemoLoginPassword;
    });
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: StaffTheme.background,
      appBar: AppBar(
        backgroundColor: StaffTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        // Hidden feature: Double tap title to trigger Demo Login.
        title: GestureDetector(
          onDoubleTap: _signInWithDemoAccount,
          child: Text(
              l10n.staffLoginTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Work Email Input Field.
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: l10n.staffWorkEmailLabel,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Input Field with Visibility Toggle.
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  // Eye icon to toggle password visibility.
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Primary Login Action Button.
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1A365D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                  )
                      : Text(
                      l10n.continueLabel,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}