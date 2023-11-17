import 'package:flutter/material.dart';

class AuthButtonWidget extends StatelessWidget {
  final Widget child;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthButtonWidget({
    required this.child,
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
