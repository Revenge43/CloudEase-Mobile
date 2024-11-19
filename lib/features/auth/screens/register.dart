import 'package:cloudease/features/auth/data/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloudease/features/auth/widgets/auth_text_form_field.dart';
import 'package:provider/provider.dart';

class RegisterFields extends StatefulWidget {
  const RegisterFields({super.key, required this.passwordConfirmationController, this.role = ''});

  final TextEditingController passwordConfirmationController;
  final String role;

  @override
  State<RegisterFields> createState() => _RegisterFieldsState();
}

class _RegisterFieldsState extends State<RegisterFields> {
  String? selectedRole = 'None';
  List<String> roles = ['None', 'Student', 'Teacher'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Password confirmation field
        AuthenticationTextFormField(
          icon: Icons.password,
          label: 'Password Confirmation',
          textEditingController: widget.passwordConfirmationController,
          validator: (value) {
            // Validate that the password matches
            if (value != widget.passwordConfirmationController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),

        // Dropdown for role selection with a prefix icon
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(),
              child: Row(
                children: [
                  // Prefix Icon
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(Icons.admin_panel_settings, color: Theme.of(context).colorScheme.primary),
                  ),
                  // Dropdown button with custom style
                  Expanded(
                    child: DropdownButton<String>(
                      underline: Container(),
                      value: selectedRole,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue;
                        });
                        
                        Provider.of<AuthProvider>(context, listen: false).saveRole(selectedRole ?? '');
                      },
                      items: roles.map<DropdownMenuItem<String>>((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      // underline: SizedBox(), // Hide the default underline
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
