import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add Firebase Auth
import 'package:groupproject_group5/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  // Track loading state during the network request
  bool _isLoading = false;

  static const Color _bg = Color(0xFFF8F8EC);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String value) {
    final String v = value.trim();
    return v.contains('@') && v.contains('.');
  }

  // Updated logic to connect to Firebase with privacy-focused messaging
  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String email = _emailController.text.trim();

    // 1. Local Validation
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgEnterYourEmail)),
      );
      return;
    }
    if (!_looksLikeEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.msgEnterValidEmail)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Call Firebase to send the reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // 3. Professional Privacy Message
      // We show this message even if the email doesn't exist to prevent account enumeration
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("If an account exists for this email, a reset link has been sent."),
            backgroundColor: Color(0xFF46AA57),
            duration: Duration(seconds: 5),
          ),
        );

        // Return to login screen
        Navigator.of(context).pop();
      }

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      // We still handle real errors (like network issues),
      // but 'user-not-found' will be treated as success by Firebase's default protection settings.
      String errorMsg = "An error occurred. Please try again later.";

      if (e.code == 'invalid-email') {
        errorMsg = "The email address is badly formatted.";
      } else if (e.code == 'network-request-failed') {
        errorMsg = "Network error. Please check your connection.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.redAccent),
      );
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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(l10n.resetPasswordTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.resetPasswordHint,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.emailLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading, // Disable input while loading
                decoration: InputDecoration(
                  hintText: l10n.emailExampleHint,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF46AA57),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF46AA57),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                      : Text(
                    l10n.sendResetLink,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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