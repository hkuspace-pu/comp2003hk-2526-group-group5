import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserProfile? _userProfile;

  // Initialize as true so the AuthWrapper shows the loading spinner
  // immediately while Firebase checks the login status.
  bool _isLoading = true;

  // Getters
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _userProfile != null;

  UserProvider() {
    _initializeAuthListener();
  }

  // Sets up a permanent listener for Firebase Auth changes.
  void _initializeAuthListener() {
    _authService.userStream.listen((User? user) async {
      if (user != null) {
        // If a user exists, fetch their detailed profile from Firestore
        await refreshProfile(user.uid);
      } else {
        // If no user, clear profile and stop loading
        _userProfile = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  // Fetches or updates the user profile from Firestore.
  Future<void> refreshProfile(String uid) async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      // Fetch the custom user document (role, XP, level, etc.)
      _userProfile = await _firestoreService.getUserProfile(uid);
    } catch (e) {
      debugPrint("Error loading profile for $uid: $e");
      _userProfile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logs the user out and clears the local provider state.
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();

      _userProfile = null;
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}