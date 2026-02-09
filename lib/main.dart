import 'package:client/routes.dart';
import 'package:client/services/context.dart';
import 'package:client/services/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Minder());
}

class Minder extends StatelessWidget {
  const Minder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Minder', navigatorKey: ContextService.key, routes: routes, initialRoute: '/login', theme: ThemeService.defaultTheme);
  }
}
