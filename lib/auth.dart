import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign In with Email and Password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error during sign-in: $e");
      rethrow;
    }
  }

  // Create User with Email and Password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String role,
    String? displayName,
    String? companyName,
    String? companyAddress,
    String? contactInfo,
    List<String>? servicesOffered,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Save user data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'displayName': displayName ?? '',
        'companyName': companyName ?? '',
        'companyAddress': companyAddress ?? '',
        'contactInfo': contactInfo ?? '',
        'servicesOffered': servicesOffered ?? [],
        'createdAt': Timestamp.now(),
        'profileCompleted': false,
      });
      print("User created successfully!");
      return userCredential;
    } catch (e) {
      print("Error creating user: $e");
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      print("User signed out successfully!");
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }

  // Get User Role
  Future<String> getUserRole(String email) async {
    try {
      var userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs.first.data()['role'] as String;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error fetching user role: $e");
      rethrow;
    }
  }

  // Add services to partner
  Future<void> addServicesToPartner({
    required String uid,
    required List<String> servicesOffered,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'servicesOffered': FieldValue.arrayUnion(servicesOffered),
      });
      print("Services added to partner successfully!");
    } catch (e) {
      print("Error adding services: $e");
      rethrow;
    }
  }
}
