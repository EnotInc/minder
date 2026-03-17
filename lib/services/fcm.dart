import 'package:firebase_messaging/firebase_messaging.dart';

class FCM {
  static Future<String> token() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token ?? '';
  }
}
