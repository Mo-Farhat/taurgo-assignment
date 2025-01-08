// partner_dashboard_view_model.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbac_crud_app/auth.dart';

class PartnerDashboardViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  late List<String> _servicesOffered;
  String? _companyName;
  String? _contactInfo;

  List<String> get servicesOffered => _servicesOffered;
  String? get companyName => _companyName;
  String? get contactInfo => _contactInfo;

  Future<void> fetchPartnerData() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_authService.currentUser!.uid)
          .get();
      var userData = userDoc.data() as Map<String, dynamic>;

      _companyName = userData['companyName'];
      _contactInfo = userData['contactInfo'];
      _servicesOffered = List<String>.from(userData['servicesOffered']);

      notifyListeners();
    } catch (e) {
      throw Exception("Error fetching partner data: $e");
    }
  }

  void addService(String service) {
    _servicesOffered.add(service);
    _updateServicesInFirestore();
    notifyListeners();
  }

  void removeService(String service) {
    _servicesOffered.remove(service);
    _updateServicesInFirestore();
    notifyListeners();
  }

  Future<void> _updateServicesInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_authService.currentUser!.uid)
          .update({'servicesOffered': _servicesOffered});
    } catch (e) {
      print("Error updating services: $e");
    }
  }
}
