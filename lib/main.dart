import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rbac_crud_app/firebase_options.dart';
import 'package:rbac_crud_app/views/client_dashboard.dart';
import 'package:rbac_crud_app/views/client_register_page.dart';
import 'package:rbac_crud_app/views/home_page.dart';
import 'package:rbac_crud_app/views/partner_dashboard.dart';
import 'package:rbac_crud_app/views/partner_detail_page.dart';
import 'package:rbac_crud_app/views/partner_register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Role-Based App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/clientsignup': (context) => ClientRegisterScreen(),
        '/partnersignup': (context) => PartnerRegister(),
        '/partnerdashboard': (context) => PartnerDashboard(),
        '/clientdashboard': (context) => ClientDashboard(),
      },
    );
  }
}
