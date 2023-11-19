import 'package:flutter/material.dart';
import 'package:my_to_do_list/features/auth/presentation/pages/register.page.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/AuthtextButtonwidget.page.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/authbuttonwidget.page.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/emailwidget.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/passwordwidget.dart';
import 'package:my_to_do_list/features/auth/repository/auth.repository.dart';
import 'package:my_to_do_list/features/todo/presentation/pages/addtodo.page.dart';
import 'package:my_to_do_list/features/todo/presentation/pages/mytodolist.page.dart';
// Update the import statement

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false; // Changed 'isloading' to 'isLoading'
  late AuthRepository authRepository;
  late ScaffoldMessengerState _snackbar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authRepository = AuthRepository();
    autoLogin();
  }

  void autoLogin() {
    setState(() => isLoading = true);
    authRepository.autologin().then((authModel) {
      ///gi off and loading
      if (authModel == null) {
        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyTodoListPage(authModel: authModel),
          ),
        );
      }
    }).catchError((e) {
      ///oagngon gihapon and loading
      setState(() => isLoading = false);
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    _snackbar = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body:
          isLoading // Use the isLoading variable to conditionally display a CircularProgressIndicator
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 5,
                      color: Colors
                          .deepPurpleAccent, // Set the background color here
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
                              color: Color.fromARGB(255, 243, 33, 208),
                            ),
                            SizedBox(height: 24.0),
                            EmailTextFormField(controller: _emailController),
                            SizedBox(height: 16.0),
                            PasswordTextFormField(
                              controller: _passwordController,
                              isPasswordVisible: _isPasswordVisible,
                              togglePasswordVisibility:
                                  _togglePasswordVisibility,
                            ),
                            SizedBox(height: 24.0),
                            AuthButtonWidget(
                              buttonText: 'Login',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  authRepository
                                      .login(_emailController.text,
                                          _passwordController.text)
                                      .then((authModel) {
                                    setState(() => isLoading = false);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MyTodoListPage(
                                            authModel: authModel),
                                      ),
                                    );
                                  }).catchError(
                                    (e) {
                                      ///gi off si loading.
                                      setState(() => isLoading = false);

                                      ///gipagawas ang snackbar
                                      _snackbar.showSnackBar(SnackBar(
                                          content: Text(e.toString())));
                                    },
                                  );
                                }
                              },
                              child: Text('Login'),
                            ),
                            const SizedBox(height: 8.0),
                            AuthTextButtonWidget(
                              text: "Don't have an account? Register",
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
