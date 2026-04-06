import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  UserProvider() {
    _currentUser = User(
      id: 'user123',
      name: 'Jeremy Lee',
      email: 'jeremy.lee@example.com',
      customerImage: const AssetImage('images/profile.png'),
    );
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    _currentUser = User(
      id: 'user123',
      name: 'Jeremy Lee',
      email: email,
      customerImage: const AssetImage('images/profile.png'),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }
}
