// partner_register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_crud_app/viewmodel/partner_register_view_model.dart';

class PartnerRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PartnerRegisterViewModel(),
      child: Consumer<PartnerRegisterViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(title: Text('Partner Registration')),
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
                    decoration: InputDecoration(labelText: 'Company Name'),
                    onChanged: viewModel.updateCompanyName,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Company Address'),
                    onChanged: viewModel.updateCompanyAddress,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Contact Info'),
                    onChanged: viewModel.updateContactInfo,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Add a service'),
                    onChanged: (value) {
                      // Update the service controller directly in viewModel
                      viewModel.addService(value);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add service to the list
                      viewModel.addService(viewModel.servicesOffered.last);
                    },
                    child: Text('Add Service'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await viewModel.registerPartner();
                        Navigator.pushNamed(context, '/partnerdashboard');
                      } catch (e) {
                        print('Error during registration: $e');
                      }
                    },
                    child: Text('Register as Partner'),
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
