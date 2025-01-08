import 'package:flutter/material.dart';
import 'package:rbac_crud_app/auth.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String _email = '';
  String _password = '';
  String _role = '';

  String get email => _email;
  String get password => _password;
  String get role => _role;

  Future<void> login(String email, String password) async {
    try {
      await _authService.signInWithEmailAndPassword(
          email: email, password: password);
      _role = await _authService.getUserRole(email);
      notifyListeners(); // Notify listeners when role is fetched
    } catch (e) {
      throw Exception("Error signing in: $e");
    }
  }

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }
}
