import 'package:flutter/material.dart';
import 'package:rbac_crud_app/auth.dart';
import 'partner_register_page.dart';
import 'client_register_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  String _email = '';
  String _password = '';

  Future<void> _handleLogin() async {
    try {
      await _authService.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      String role = await _authService.getUserRole(_email); // Fetch user role

      if (role == 'Client') {
        Navigator.pushNamed(context, '/clientdashboard');
      } else if (role == 'Partner') {
        Navigator.pushNamed(context, '/partnerdashboard');
      } else {
        print("Unknown role");
      }
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  void _navigateToClientRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientRegisterScreen(),
      ),
    );
  }

  void _navigateToPartnerRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartnerRegister(),
      ),
    );
  }

  void _showSignUpOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Client'),
              onTap: () => _navigateToClientRegistration(context),
            ),
            ListTile(
              title: Text('Partner'),
              onTap: () => _navigateToPartnerRegistration(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Taurgo"))),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter your email here'),
              onChanged: (value) => setState(() => _email = value),
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Enter your password here'),
              obscureText: true,
              onChanged: (value) => setState(() => _password = value),
            ),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _showSignUpOptions(context),
              child: Text('Sign Up as New User'),
            ),
          ],
        ),
      ),
    );
  }
}
