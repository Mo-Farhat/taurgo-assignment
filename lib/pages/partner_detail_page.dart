import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbac_crud_app/auth.dart'; // Assuming you have this AuthService to manage the user session

class PartnerDetailPage extends StatefulWidget {
  final Map<String, dynamic> partner;

  PartnerDetailPage({required this.partner});

  @override
  _PartnerDetailPageState createState() => _PartnerDetailPageState();
}

class _PartnerDetailPageState extends State<PartnerDetailPage> {
  final AuthService _authService = AuthService();
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkIfConnected();
  }

  // Check if the current client is already connected to this partner
  Future<void> _checkIfConnected() async {
    String uid = _authService.currentUser!.uid;
    DocumentSnapshot clientDoc =
        await FirebaseFirestore.instance.collection('clients').doc(uid).get();

    if (clientDoc.exists) {
      setState(() {
        isConnected = (clientDoc['connectedPartners'] as List)
            .contains(widget.partner['partnerId']);
      });
    }
  }

  // Connect with partner
  Future<void> _connectWithPartner() async {
    String uid = _authService.currentUser!.uid;
    try {
      await FirebaseFirestore.instance.collection('clients').doc(uid).update({
        'connectedPartners':
            FieldValue.arrayUnion([widget.partner['partnerId']]),
      });
      setState(() {
        isConnected = true;
      });
      print("Connected with partner successfully!");
    } catch (e) {
      print("Error connecting with partner: $e");
    }
  }

  // Disconnect from partner
  Future<void> _disconnectFromPartner() async {
    String uid = _authService.currentUser!.uid;
    try {
      await FirebaseFirestore.instance.collection('clients').doc(uid).update({
        'connectedPartners':
            FieldValue.arrayRemove([widget.partner['partnerId']]),
      });
      setState(() {
        isConnected = false;
      });
      print("Disconnected from partner successfully!");
    } catch (e) {
      print("Error disconnecting from partner: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var companyName = widget.partner['companyName'];
    var servicesOffered = widget.partner['servicesOffered'];

    return Scaffold(
      appBar: AppBar(
        title: Text(companyName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services Offered:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...servicesOffered.map<Widget>((service) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(service),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  isConnected ? _disconnectFromPartner : _connectWithPartner,
              child: Text(isConnected
                  ? 'Disconnect from Partner'
                  : 'Connect with Partner'),
            ),
          ],
        ),
      ),
    );
  }
}
