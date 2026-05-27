import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to monitor login status (Used in UserProvider)
  Stream<User?> get userStream => _auth.authStateChanges();

  // Get current user UID
  String? get currentUserUid => _auth.currentUser?.uid;

  // Sign In logic
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  // Sign Up logic
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  // Sign Out logic
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Password Reset (Matches your original LoginScreen logic)
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}