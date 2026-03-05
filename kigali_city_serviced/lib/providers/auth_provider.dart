import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isEmailVerified => _currentUser?.emailVerified ?? false;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((user) {
      _currentUser = user;
      if (user != null) {
        _loadUserProfile(user.uid);
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      _userProfile = await _authService.getUserProfile(uid);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signOut();
      _userProfile = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      await _authService.reloadUser();
      _currentUser = _authService.currentUser;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.updateUserProfile(
        uid: _currentUser!.uid,
        displayName: displayName,
        photoUrl: photoUrl,
      );
      await _loadUserProfile(_currentUser!.uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNotificationPreference(bool enabled) async {
    if (_currentUser == null) return;

    try {
      await _authService.updateNotificationPreference(
        uid: _currentUser!.uid,
        enabled: enabled,
      );
      if (_userProfile != null) {
        _userProfile = _userProfile!.copyWith(notificationsEnabled: enabled);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
