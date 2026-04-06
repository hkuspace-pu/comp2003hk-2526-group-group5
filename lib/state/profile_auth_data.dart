import 'package:flutter/foundation.dart';

class AuthData extends ChangeNotifier {
  final String _correctEmail = 'jeremy.lee@example.com';
  final String _correctPassword = 'password123';

  Future<bool> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return email == _correctEmail && password == _correctPassword;
  }
}
