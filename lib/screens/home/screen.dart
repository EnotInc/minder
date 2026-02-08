import 'package:client/screens/home/viewmoder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => HomeViewModel(), child: HomeView());
  }
}
