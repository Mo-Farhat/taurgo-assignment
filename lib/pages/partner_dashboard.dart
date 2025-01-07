import 'package:flutter/material.dart';
import 'package:rbac_crud_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerDashboard extends StatefulWidget {
  @override
  _PartnerDashboardState createState() => _PartnerDashboardState();
}

class _PartnerDashboardState extends State<PartnerDashboard> {
  final AuthService _authService = AuthService();
  late List<String> services;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Partner Dashboard')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(_authService.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No profile data"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          services = List<String>.from(userData['servicesOffered']);

          return Column(
            children: [
              ListTile(
                title: Text("Company Name: ${userData['companyName']}"),
              ),
              ListTile(
                title: Text("Contact Info: ${userData['contactInfo']}"),
              ),
              ListTile(
                title: Text("Services Offered:"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: services.map<Widget>((service) {
                    return Text(service);
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Show dialog to add/remove services
                  _showServiceDialog(context);
                },
                child: Text('Manage Services'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the profile update page
                },
                child: Text('Update Profile'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Method to show the dialog for adding/removing services
  void _showServiceDialog(BuildContext context) {
    final TextEditingController _serviceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Manage Services'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _serviceController,
                decoration: InputDecoration(labelText: 'Service'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_serviceController.text.isNotEmpty) {
                    setState(() {
                      // Add the service and update Firestore
                      services.add(_serviceController.text);
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(_authService.currentUser!.uid)
                          .update({
                        'servicesOffered': services,
                      });
                    });
                    Navigator.pop(context); // Close the dialog
                  }
                },
                child: Text('Add Service'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Remove service if it exists
                  String serviceToRemove = _serviceController.text;
                  if (services.contains(serviceToRemove)) {
                    setState(() {
                      services.remove(serviceToRemove);
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(_authService.currentUser!.uid)
                          .update({
                        'servicesOffered': services,
                      });
                    });
                    Navigator.pop(context); // Close the dialog
                  }
                },
                child: Text('Remove Service'),
              ),
            ],
          ),
        );
      },
    );
  }
}
