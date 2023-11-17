// confirm_password_text_form_field.dart

import 'package:flutter/material.dart';
import 'package:my_to_do_list/core/guard.dart';

class ConfirmPasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool isConfirmationPasswordVisible;
  final Function toggleConfirmationPasswordVisibility;
  final String password;

  const ConfirmPasswordTextFormField({
    Key? key,
    required this.controller,
    required this.isConfirmationPasswordVisible,
    required this.toggleConfirmationPasswordVisibility,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Enter Confirm Password",
        labelText: "Confirm Password",
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            isConfirmationPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            toggleConfirmationPasswordVisibility();
          },
        ),
      ),
      obscureText: !isConfirmationPasswordVisible,
      validator: (String? value) {
        return Guard.validateConfirmPassword(value, password);
      },
    );
  }
}
