import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/staff_provider.dart';

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final _email = TextEditingController(text: 'staff@demo.hk');
  final _password = TextEditingController();

  static const Color _accent = Color(0xFF2B579A);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final staff = context.read<StaffProvider>();
    final ok = await staff.login(_email.text, _password.text);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign-in failed. Use an email containing "staff" and a password of at least 4 characters.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: const Text('Staff login'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 8),
            const Text(
              'Sign in with your staff account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Demo: email must contain "staff" (e.g. staff@demo.hk)',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec('Staff email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: _dec('Password'),
            ),
            const SizedBox(height: 28),
            Consumer<StaffProvider>(
              builder: (context, staff, _) {
                return FilledButton(
                  onPressed: staff.isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: _accent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: staff.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Sign in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
