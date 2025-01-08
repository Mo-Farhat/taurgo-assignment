// client_register_view_model.dart
import 'package:flutter/material.dart';
import 'package:rbac_crud_app/auth.dart';

class ClientRegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String _email = '';
  String _password = '';
  String _displayName = '';

  String get email => _email;
  String get password => _password;
  String get displayName => _displayName;

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  void updateDisplayName(String value) {
    _displayName = value;
    notifyListeners();
  }

  Future<void> registerClient() async {
    try {
      await _authService.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
        role: 'Client', // Role is set to 'Client' for this screen
        displayName: _displayName,
      );
    } catch (e) {
      throw Exception('Error registering client: $e');
    }
  }
}
