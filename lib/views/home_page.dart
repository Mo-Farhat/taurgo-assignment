// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_crud_app/viewmodel/home_view_model.dart';
import 'client_register_page.dart';
import 'partner_register_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(title: Center(child: Text("Taurgo"))),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration:
                        InputDecoration(labelText: 'Enter your email here'),
                    onChanged: viewModel.updateEmail,
                  ),
                  TextField(
                    decoration:
                        InputDecoration(labelText: 'Enter your password here'),
                    obscureText: true,
                    onChanged: viewModel.updatePassword,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await viewModel.login(
                            viewModel.email, viewModel.password);
                        String role = viewModel.role;
                        if (role == 'Client') {
                          Navigator.pushNamed(context, '/clientdashboard');
                        } else if (role == 'Partner') {
                          Navigator.pushNamed(context, '/partnerdashboard');
                        } else {
                          print("Unknown role");
                        }
                      } catch (e) {
                        print("Error: $e");
                      }
                    },
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
        },
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
}
