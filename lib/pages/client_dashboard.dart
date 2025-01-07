import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbac_crud_app/auth.dart';
import 'package:rbac_crud_app/pages/partner_detail_page.dart'; // Import PartnerDetailPage

class ClientDashboard extends StatefulWidget {
  @override
  _ClientDashboardState createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _displayName = '';
  List<String> _connectedPartners = [];

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  // Load client data
  Future<void> _loadClientData() async {
    String uid = _authService.currentUser!.uid;
    DocumentSnapshot clientDoc =
        await _firestore.collection('clients').doc(uid).get();

    if (clientDoc.exists) {
      setState(() {
        _displayName = clientDoc['displayName'] ?? '';
        _connectedPartners =
            List<String>.from(clientDoc['connectedPartners'] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('partners')
            .snapshots(), // Listen to real-time updates for partners
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No available partners"));
          }

          var partners = snapshot.data!.docs.map((doc) {
            return {
              'partnerId': doc.id,
              'companyName': doc['companyName'],
            };
          }).toList();

          return ListView.builder(
            itemCount: partners.length,
            itemBuilder: (context, index) {
              var partner = partners[index];
              var partnerId = partner['partnerId'];
              var companyName = partner['companyName'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(companyName),
                  subtitle: _buildPartnerServicesStream(partnerId),
                  trailing: _connectedPartners.contains(partnerId)
                      ? IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () => _disconnectFromPartner(partnerId),
                        )
                      : IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () => _connectWithPartner(partnerId),
                        ),
                  onTap: () {
                    // Navigate to the partner detail page when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PartnerDetailPage(partner: partner),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Build Stream for services offered by a partner
  Widget _buildPartnerServicesStream(String partnerId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('partners').doc(partnerId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading services...');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No services available');
        }

        var services =
            List<String>.from(snapshot.data!['servicesOffered'] ?? []);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: services.map<Widget>((service) {
            return Text(service);
          }).toList(),
        );
      },
    );
  }

  // Connect with partner
  Future<void> _connectWithPartner(String partnerId) async {
    String uid = _authService.currentUser!.uid;
    try {
      await _firestore.collection('clients').doc(uid).update({
        'connectedPartners': FieldValue.arrayUnion([partnerId]),
      });
      setState(() {
        _connectedPartners.add(partnerId);
      });
      print("Connected with partner successfully!");
    } catch (e) {
      print("Error connecting with partner: $e");
    }
  }

  // Disconnect from partner
  Future<void> _disconnectFromPartner(String partnerId) async {
    String uid = _authService.currentUser!.uid;
    try {
      await _firestore.collection('clients').doc(uid).update({
        'connectedPartners': FieldValue.arrayRemove([partnerId]),
      });
      setState(() {
        _connectedPartners.remove(partnerId);
      });
      print("Disconnected from partner successfully!");
    } catch (e) {
      print("Error disconnecting from partner: $e");
    }
  }
}
