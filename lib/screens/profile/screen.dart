import 'package:client/screens/profile/view.dart';
import 'package:client/screens/profile/viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ProfileViewModel(), child: ProfileView());
  }
}
