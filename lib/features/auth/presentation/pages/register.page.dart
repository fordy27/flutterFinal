import 'package:flutter/material.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/authbuttonwidget.page.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/confirmpasswidget.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/emailwidget.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/passwords.dart';
import 'package:my_to_do_list/features/auth/repository/auth.repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late GlobalKey<FormState> _formKey;
  bool _isPasswordVisible = false;
  bool _isConfirmationPasswordVisible = false;
  String _password = '';

  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _confirmPasswordController =
      TextEditingController();

//declare
  late AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _formKey = GlobalKey();
    //initialize authrepository
    _authRepository = AuthRepository();
  }

  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmationPasswordVisibility() {
    setState(() {
      _isConfirmationPasswordVisible = !_isConfirmationPasswordVisible;
    });
  }

  void _updatePassword(String newPassword) {
    setState(() {
      _password = newPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Card(
                elevation: 5,
                color: const Color.fromARGB(255, 51, 74, 112),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 100.0,
                        color: const Color.fromARGB(255, 243, 33, 131),
                      ),
                      SizedBox(height: 24.0),
                      EmailTextFormField(controller: _emailController),
                      SizedBox(height: 16.0),
                      PasswordsTextFormField(
                        controller: _passwordController,
                        isPasswordVisible: _isPasswordVisible,
                        togglePasswordVisibility: _togglePasswordVisibility,
                        updatePassword: _updatePassword,
                      ),
                      SizedBox(height: 16.0),
                      ConfirmPasswordTextFormField(
                        controller: _confirmPasswordController,
                        isConfirmationPasswordVisible:
                            _isConfirmationPasswordVisible,
                        toggleConfirmationPasswordVisibility:
                            _toggleConfirmationPasswordVisibility,
                        password: _password,
                      ),
                      SizedBox(height: 24.0),
                      AuthButtonWidget(
                        buttonText: 'Register',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _startLoading();
                            _authRepository
                                .register(_emailController.text,
                                    _passwordController.text)
                                .then((value) {
                              _stopLoading();
                              _showSnackbar('Registration successful');
                              print('Success');
                            }).catchError((error) {
                              _stopLoading();
                              _showSnackbar('Error: $error');
                              print('Error: $error');
                            });
                          }
                        },
                        child: Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
