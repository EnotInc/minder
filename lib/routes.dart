import 'package:client/screens/auth/login/screen.dart';
import 'package:client/screens/auth/register/screen.dart';
import 'package:client/screens/note_edit.dart/screen.dart';
import 'package:client/screens/profile/screen.dart';

import 'screens/home/screen.dart';

final routes = {
  '/login': (_) => LoginScreen(),
  '/register': (_) => RegisterScreen(),
  '/home': (_) => const HomeScreen(),
  '/note_edit': (_) => NoteEditScreen(),
  '/profile': (_) => ProfileScreen(),
  //
};
