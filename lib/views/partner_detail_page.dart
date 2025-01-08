// partner_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_crud_app/viewmodel/partner_detail_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerDetailPage extends StatelessWidget {
  final Map<String, dynamic> partner;

  PartnerDetailPage({required this.partner});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          PartnerDetailViewModel(partnerId: partner['partnerId']),
      child: Consumer<PartnerDetailViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(partner['companyName']),
            ),
            body: StreamBuilder<DocumentSnapshot>(
              stream: viewModel.partnerStream,
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

                viewModel.updateServices(servicesOffered);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Services Offered:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ...viewModel.servicesOffered.map<Widget>((service) {
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
        },
      ),
    );
  }
}
