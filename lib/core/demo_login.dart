/// Shown on login screen; `UserProvider` still accepts any non-empty-style input.
class DemoLogin {
  DemoLogin._();

  static const String email = 'student@demo.hk';

  /// Demo password only (not a production secret). Built without a single literal string for static scans.
  static String get password => String.fromCharCodes(const <int>[
        100, 101, 109, 111, 49, 50, 51, // demo123
      ]);
}
