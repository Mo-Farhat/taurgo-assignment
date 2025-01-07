import 'package:flutter/material.dart';
import 'package:rbac_crud_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerRegister extends StatefulWidget {
  @override
  _PartnerRegisterState createState() => _PartnerRegisterState();
}

class _PartnerRegisterState extends State<PartnerRegister> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _email = '';
  String _password = '';
  String _companyName = '';
  String _companyAddress = '';
  String _contactInfo = '';
  List<String> _servicesOffered = []; // Store services

  final TextEditingController _serviceController = TextEditingController();

  void _addService() {
    if (_serviceController.text.isNotEmpty) {
      setState(() {
        _servicesOffered.add(_serviceController.text);
        _serviceController.clear();
      });
    }
  }

  // Save partner data to Firestore
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
      print("Error saving partner data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Partner Registration')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => _email = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) => _password = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Company Name'),
              onChanged: (value) => _companyName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Company Address'),
              onChanged: (value) => _companyAddress = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Contact Info'),
              onChanged: (value) => _contactInfo = value,
            ),
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Add a service'),
            ),
            ElevatedButton(
              onPressed: _addService,
              child: Text('Add Service'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Create the user and get the userCredential
                  var userCredential =
                      await _authService.createUserWithEmailAndPassword(
                    email: _email,
                    password: _password,
                    role: 'Partner',
                    companyName: _companyName,
                    companyAddress: _companyAddress,
                    contactInfo: _contactInfo,
                    servicesOffered: _servicesOffered,
                  );

                  // After user is created, save partner data to Firestore
                  if (userCredential.user != null) {
                    await _savePartnerToFirestore(userCredential.user!.uid);
                    Navigator.pushNamed(context, '/partnerdashboard');
                  }
                } catch (e) {
                  print("Error during registration: $e");
                }
              },
              child: Text('Register as Partner'),
            ),
          ],
        ),
      ),
    );
  }
}
