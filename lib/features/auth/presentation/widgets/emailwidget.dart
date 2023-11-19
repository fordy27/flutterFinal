// email_text_form_field.dart

import 'package:flutter/material.dart';
import 'package:my_to_do_list/core/guard.dart';

class EmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  const EmailTextFormField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Enter Email",
        labelText: "Email",
        prefixIcon: Icon(Icons.email),
      ),
      validator: (String? value) {
        return Guard.invalidEmail(value, 'Email');
      },
    );
  }
}
