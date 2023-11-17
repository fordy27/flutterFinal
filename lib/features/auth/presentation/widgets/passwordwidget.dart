// password_text_form_field.dart

import 'package:flutter/material.dart';
import 'package:my_to_do_list/core/guard.dart';

class PasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  final Function togglePasswordVisibility;

  const PasswordTextFormField({
    Key? key,
    required this.controller,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Enter Password",
        labelText: "Password",
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            togglePasswordVisibility();
          },
        ),
      ),
      obscureText: !isPasswordVisible,
      validator: (String? value) {
        return Guard.validatePassword(value, 'Password');
      },
    );
  }
}
