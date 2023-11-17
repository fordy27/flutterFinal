import 'package:flutter/material.dart';

class AuthTextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthTextButtonWidget({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }
}
