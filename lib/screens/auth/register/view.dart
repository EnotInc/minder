import 'package:client/services/theme.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final login = TextEditingController();
  final password = TextEditingController();
  final repeat = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              Expanded(child: SizedBox()),
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
                            return null;
                          },
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          controller: password,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(labelText: 'password'),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Enter password';
                            return null;
                          },
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          controller: repeat,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(labelText: 'repeat'),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Enter password';
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
                      Navigator.of(context).popAndPushNamed('/login');
                    },
                    child: Text(
                      "Login right now!",
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                    ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: ThemeService.authColor),
                  child: TextButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        Navigator.of(context).popAndPushNamed('/home');
                      }
                    },
                    child: Text('Регистрация'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
