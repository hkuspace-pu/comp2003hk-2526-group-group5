import 'package:flutter/foundation.dart';

import '../core/demo_login.dart';

/// Built-in demo account for the staff portal (local demo only; replace with real auth later).
class StaffDemoCredentials {
  StaffDemoCredentials._();

  static const String email = 'staff@demo.hk';

  /// Same scheme as [DemoLogin.password] with an extra digit (demo-only).
  static String get password => '${DemoLogin.password}4';
}

/// Demo staff account for the staff portal (replace with real auth later).
class StaffUser {
  const StaffUser({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;
}

class StaffProvider extends ChangeNotifier {
  StaffUser? _current;
  bool _loading = false;

  StaffUser? get currentStaff => _current;
  bool get isLoading => _loading;

  /// Demo: fixed account [StaffDemoCredentials], or any email containing "staff" with password length ≥ 4.
  Future<bool> login(String email, String password) async {
    final trimmed = email.trim();
    final bool matchesDemo = trimmed.toLowerCase() ==
            StaffDemoCredentials.email.toLowerCase() &&
        password == StaffDemoCredentials.password;
    final bool loose =
        trimmed.isNotEmpty &&
            trimmed.toLowerCase().contains('staff') &&
            password.length >= 4;
    if (!matchesDemo && !loose) {
      return false;
    }
    _loading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (matchesDemo) {
      _current = const StaffUser(
        id: 'staff-demo',
        name: 'Demo Staff',
        email: StaffDemoCredentials.email,
      );
    } else {
      final local = trimmed.split('@').first;
      _current = StaffUser(
        id: 'staff-${trimmed.hashCode}',
        name: local.isEmpty ? 'Staff' : local[0].toUpperCase() + local.substring(1),
        email: trimmed,
      );
    }
    _loading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _current = null;
    notifyListeners();
  }
}
