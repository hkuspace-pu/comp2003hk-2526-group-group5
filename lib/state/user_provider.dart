import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 800));
    final String safeName =
        email.trim().isEmpty ? 'User' : email.split('@').first;
    _currentUser = User(
      id: 'local-${email.hashCode}',
      name: safeName,
      email: email.trim().isEmpty ? 'user@example.com' : email.trim(),
      customerImage: const AssetImage('images/profile.png'),
    );

    _isLoading = false;
    notifyListeners();
  }

  void registerLocalAccount({required String name, required String email}) {
    _currentUser = User(
      id: 'reg-${email.hashCode}',
      name: name,
      email: email,
      customerImage: const AssetImage('images/profile.png'),
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 400));
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }
}
