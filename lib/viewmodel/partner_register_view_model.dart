// partner_register_view_model.dart
import 'package:flutter/material.dart';
import 'package:rbac_crud_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerRegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _email = '';
  String _password = '';
  String _companyName = '';
  String _companyAddress = '';
  String _contactInfo = '';
  List<String> _servicesOffered = [];

  String get email => _email;
  String get password => _password;
  String get companyName => _companyName;
  String get companyAddress => _companyAddress;
  String get contactInfo => _contactInfo;
  List<String> get servicesOffered => _servicesOffered;

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  void updateCompanyName(String value) {
    _companyName = value;
    notifyListeners();
  }

  void updateCompanyAddress(String value) {
    _companyAddress = value;
    notifyListeners();
  }

  void updateContactInfo(String value) {
    _contactInfo = value;
    notifyListeners();
  }

  void addService(String service) {
    if (!_servicesOffered.contains(service) && service.isNotEmpty) {
      _servicesOffered.add(service);
      notifyListeners(); // Notify listeners to update UI
    }
  }

  Future<void> registerPartner() async {
    try {
      var userCredential = await _authService.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
        role: 'Partner',
        companyName: _companyName,
        companyAddress: _companyAddress,
        contactInfo: _contactInfo,
        servicesOffered: _servicesOffered,
      );

      if (userCredential.user != null) {
        await _savePartnerToFirestore(userCredential.user!.uid);
      }
    } catch (e) {
      throw Exception('Error registering partner: $e');
    }
  }

  Future<void> _savePartnerToFirestore(String partnerId) async {
    try {
      await _firestore.collection('partners').doc(partnerId).set({
        'companyName': _companyName,
        'companyAddress': _companyAddress,
        'contactInfo': _contactInfo,
        'servicesOffered': _servicesOffered,
      });
      print("Partner data saved to Firestore successfully!");
    } catch (e) {
      throw Exception('Error saving partner data: $e');
    }
  }
}
