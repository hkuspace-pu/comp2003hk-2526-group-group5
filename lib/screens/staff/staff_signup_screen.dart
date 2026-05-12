import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import 'staff_shell_screen.dart';
import 'staff_theme.dart';

/// Staff sign-up UI (local validation only).
class StaffSignUpScreen extends StatefulWidget {
  const StaffSignUpScreen({super.key});

  @override
  State<StaffSignUpScreen> createState() => _StaffSignUpScreenState();
}

class _StaffSignUpScreenState extends State<StaffSignUpScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _acceptedTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false; // Tracks registration progress

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String value) {
    final String v = value.trim();
    return v.contains('@') && v.contains('.');
  }

  // Updated _submit to handle Firebase logic
  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // 1. Validation Checks
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgAcceptStaffTerms)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Create User in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 3. Save User Details (Full Name) to Firestore
      // We use the UID from Auth as the Document ID in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': name,
        'email': email,
        'role': 'staff', // Useful for distinguishing between users and staff
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // 4. Navigate to Staff Shell on Success
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => StaffShellScreen(
            staffDisplayName: name,
            staffEmail: email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      // Provide user-friendly feedback for common Firebase errors
      String errorMsg = e.message ?? "Registration failed";
      if (e.code == 'email-already-in-use') {
        errorMsg = "This email is already registered.";
      } else if (e.code == 'weak-password') {
        errorMsg = "The password provided is too weak.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.redAccent),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: StaffTheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: StaffTheme.background,
      appBar: AppBar(
        backgroundColor: StaffTheme.background,
        foregroundColor: StaffTheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.signUp),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                l10n.staffAccountTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: StaffTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.staffRegisterHint,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // Full Name
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(l10n.fullNameLabel),
              ),
              const SizedBox(height: 16),
              // Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(l10n.staffWorkEmailLabel),
              ),
              const SizedBox(height: 16),
              // Password
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(l10n.passwordLabel).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: _inputDecoration(l10n.confirmPasswordLabel).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _showConfirmPassword = !_showConfirmPassword),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Terms Checkbox
              CheckboxListTile(
                value: _acceptedTerms,
                activeColor: StaffTheme.primary,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(l10n.staffAuthorizedConfirm),
                onChanged: (bool? v) => setState(() => _acceptedTerms = v ?? false),
              ),
              const SizedBox(height: 24),
              // Sign Up Button with Loading Indicator
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: StaffTheme.primary,
                    foregroundColor: StaffTheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                  )
                      : Text(
                    l10n.signUp,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
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