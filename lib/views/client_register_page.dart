// client_register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_crud_app/viewmodel/client_register_view_model.dart';

class ClientRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ClientRegisterViewModel(),
      child: Consumer<ClientRegisterViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(title: Text('Client Registration')),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    onChanged: viewModel.updateEmail,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onChanged: viewModel.updatePassword,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Display Name'),
                    onChanged: viewModel.updateDisplayName,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await viewModel.registerClient();
                        Navigator.pushNamed(context, '/clientdashboard');
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    child: Text('Register as Client'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
