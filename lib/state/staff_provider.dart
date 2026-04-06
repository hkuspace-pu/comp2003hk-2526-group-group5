import 'package:flutter/foundation.dart';

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

  /// Demo: accept email containing "staff" and password length ≥ 4.
  Future<bool> login(String email, String password) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty || password.length < 4) {
      return false;
    }
    _loading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final bool ok = trimmed.toLowerCase().contains('staff');
    if (ok) {
      final local = trimmed.split('@').first;
      _current = StaffUser(
        id: 'staff-${trimmed.hashCode}',
        name: local.isEmpty ? 'Staff' : local[0].toUpperCase() + local.substring(1),
        email: trimmed,
      );
    }
    _loading = false;
    notifyListeners();
    return ok;
  }

  void logout() {
    _current = null;
    notifyListeners();
  }
}
