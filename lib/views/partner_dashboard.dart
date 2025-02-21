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
    // Check if the current user is logged in
    var currentUser = _authService.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Partner Dashboard')),
        body: Center(child: Text('Please log in to access your dashboard.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Partner Dashboard')),
      body: FutureBuilder<DocumentSnapshot>(
        // Fetch the partner data from Firestore
        future: FirebaseFirestore.instance
            .collection('partners') // Change 'users' to 'partners'
            .doc(currentUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No profile data available"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          services = List<String>.from(userData['servicesOffered'] ?? []);

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
                      _updateServicesInFirestore();
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
                      _updateServicesInFirestore();
                    });
                    Navigator.pop(context); // Close the dialog
                  } else {
                    // Show message if service doesn't exist
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Service not found")));
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

  // Helper function to update services in Firestore
  Future<void> _updateServicesInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('partners') // Change 'users' to 'partners'
          .doc(_authService.currentUser!.uid)
          .update({
        'servicesOffered': services,
      });
    } catch (e) {
      print("Error updating services: $e");
    }
  }
}
