import 'package:flutter/material.dart';
import 'package:rbac_crud_app/auth.dart';

class ClientRegisterScreen extends StatefulWidget {
  @override
  _ClientRegisterScreenState createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  final AuthService _authService = AuthService();
  String _email = '';
  String _password = '';
  String _displayName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Registration')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => _email = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) => _password = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Display Name'),
              onChanged: (value) => _displayName = value,
            ),
            ElevatedButton(
              onPressed: () async {
                await _authService.createUserWithEmailAndPassword(
                  email: _email,
                  password: _password,
                  role: 'Client', // Role is set to 'Client' for this screen
                  displayName: _displayName,
                );
                Navigator.pushNamed(context, '/clientdashboard');
              },
              child: Text('Register as Client'),
            ),
          ],
        ),
      ),
    );
  }
}
