import 'package:client/screens/auth/login/viewmodel.dart';
import 'package:client/services/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final login = TextEditingController();
  final password = TextEditingController();
  final _key = GlobalKey<FormState>();

  final loginLen = 6;
  final passwordLen = 6;

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeService.mainBackground,
        body: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(child: Image.asset('assets/MinderLogoV4.png', width: 128, height: 128)),
                  Form(
                    key: _key,
                    child: Card(
                      color: ThemeService.authColor,
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(32),
                        child: Column(
                          spacing: 32,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: login,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(labelText: 'login/email'),
                              validator: (value) {
                                final v = value?.trim() ?? '';
                                if (v.isEmpty) return 'Enter login or email';
                                if (v.length < loginLen) return 'Login must me bigger than $loginLen symbols';
                                viewModel.email = login.text;
                                return null;
                              },
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: password,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscure = !_obscure;
                                    });
                                  },
                                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                              validator: (value) {
                                final v = value?.trim() ?? '';
                                if (v.isEmpty) return 'Enter password';
                                if (v.length < passwordLen) return 'Password must be bigger than $passwordLen symbols';
                                viewModel.passoword = password.text;
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: Text(
                          "Create a new one!",
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsetsGeometry.all(32),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: ThemeService.authColor),
              child: TextButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    viewModel.loginUser();
                  }
                },
                child: Text('Login'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
