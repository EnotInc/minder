import 'package:client/firebase_options.dart';
import 'package:client/routes.dart';
import 'package:client/services/api.dart';
import 'package:client/services/context.dart';
import 'package:client/services/storage.dart';
import 'package:client/services/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission(provisional: true);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  String initialRoute = "/login";

  if (await ApiService().isAlive() && await StorageService().isLoggedIn()) {
    initialRoute = "/home";
  }

  runApp(Minder(initialRoute: initialRoute));
}

class Minder extends StatelessWidget {
  const Minder({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Minder', navigatorKey: ContextService.key, routes: routes, initialRoute: initialRoute, theme: ThemeService.defaultTheme);
  }
}
