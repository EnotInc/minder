import 'package:client/screens/auth/login/view.dart';
import 'package:client/screens/auth/login/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => LoginViewModer(), child: LoginView());
  }
}
