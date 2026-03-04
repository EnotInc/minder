import 'package:client/screens/auth/register/viewmodel.dart';
import 'package:client/services/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final login = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final repeat = TextEditingController();
  final _key = GlobalKey<FormState>();

  final loginLen = 6;
  final passwordLen = 6;

  bool _obscure = true;
  bool _obscureRepeat = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterviewModel>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              Center(child: Image.asset('assets/MinderLogoV4.png', width: 256, height: 256)),
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
                          decoration: InputDecoration(labelText: 'login'),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Enter login';
                            if (v.length < loginLen) return 'Login must be bigger than $loginLen symbols';
                            viewModel.login = login.text;
                            return null;
                          },
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(labelText: 'email'),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Enter email';
                            if (v.length < loginLen) return 'Login must be bigger than $loginLen symbols';
                            viewModel.email = email.text;
                            return null;
                          },
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          controller: password,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
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
                          obscureText: _obscure,
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Enter password';
                            if (v.length < passwordLen) return 'Password must be bigger than $passwordLen symbols';
                            return null;
                          },
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          controller: repeat,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          obscureText: _obscureRepeat,
                          decoration: InputDecoration(
                            labelText: 'repeat',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureRepeat = !_obscureRepeat;
                                });
                              },
                              icon: Icon(_obscureRepeat ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Enter password';
                            if (v.length < passwordLen) return 'Password must be bigger than $passwordLen symbols';
                            if (password.text != repeat.text) return 'Passwords must be the same';
                            viewModel.passoword = repeat.text;
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
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      "Login right now!",
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 0),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: ThemeService.authColor),
              child: TextButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    viewModel.registerUser();
                  }
                },
                child: Text('Регистрация'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
