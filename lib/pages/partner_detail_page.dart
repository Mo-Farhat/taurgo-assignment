import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerDetailPage extends StatelessWidget {
  final Map<String, dynamic> partner;

  PartnerDetailPage({required this.partner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(partner['companyName']),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('partners')
            .doc(partner['partnerId']) // Listen for changes in this partner
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No partner data available"));
          }

          var partnerData = snapshot.data!.data() as Map<String, dynamic>;
          List<String> servicesOffered =
              List<String>.from(partnerData['servicesOffered']);

          return Padding(
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
              ],
            ),
          );
        },
      ),
    );
  }
}
