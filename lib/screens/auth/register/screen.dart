import 'package:client/screens/auth/register/view.dart';
import 'package:client/screens/auth/register/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => RegisterviewModel(), child: RegisterView());
  }
}
