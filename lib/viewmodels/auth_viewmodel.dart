import 'package:flutter/material.dart';
import '../repositories/auth_repo.dart';
import '../models/user_model.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  AuthViewModel() {
    // Consider implementing user session management to check for a current user session here
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      UserModel? user = await _authRepo.login(email, password);
      if (user != null) {
        _setCurrentUser(user);
      } else {
        _setErrorMessage("Login failed. Please check your credentials and try again.");
      }
    } catch (e) {
      _setErrorMessage("An error occurred. Please try again later.");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(UserModel user, String password) async {
    _setLoading(true);
    try {
      bool success = await _authRepo.register(user, password);
      if (success) {
        await login(user.email!, password); // Automatically log in the user after successful registration
      } else {
        _setErrorMessage("Registration failed. Please try again.");
      }
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void logout() {
    _setCurrentUser(null);
    // Implement logout logic here, possibly including clearing of session data
    notifyListeners();
    // Note: If using Firebase Auth, call FirebaseAuth.instance.signOut();
  }
}
