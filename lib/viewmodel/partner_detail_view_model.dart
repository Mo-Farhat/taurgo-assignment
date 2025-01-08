// partner_detail_view_model.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerDetailViewModel extends ChangeNotifier {
  final String partnerId;
  List<String> _servicesOffered = [];

  List<String> get servicesOffered => _servicesOffered;

  PartnerDetailViewModel({required this.partnerId});

  Stream<DocumentSnapshot> get partnerStream {
    return FirebaseFirestore.instance
        .collection('partners')
        .doc(partnerId)
        .snapshots();
  }

  void updateServices(List<String> services) {
    _servicesOffered = services;
    notifyListeners();
  }
}
