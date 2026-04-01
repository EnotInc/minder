import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api_modules/auth/auth.dart';
import '../../../api_modules/body/body.dart';
import '../../../enums/tokens.dart';
import '../../../services/api.dart';
import '../../../services/context.dart';
import '../../../services/fcm.dart';
import '../../../services/helper.dart';
import '../../../services/storage.dart';

class RegisterviewModel extends ChangeNotifier {
  String login = "";
  String email = "";
  String passoword = "";

  Future<void> registerUser() async {
    try {
      final token = await FCM.token();
      Map<String, dynamic> body = {"username": login, "email": email, "password": passoword, "fcmToken": token};

      final Response<dynamic>? response = await ApiService().post(path: "auth/register", body: body);
      if (response != null) {
        final model = Body<Auth>.fromJson(response.data, (json) => Auth.fromJson(json as Map<String, dynamic>));

        if (model.success) {
          if (model.data != null) {
            if (model.data!.accesToken == null || model.data!.refreshToken == null) {
              throw ("unable to login");
            }
            StorageService().saveToken(type: Token.access.name, token: model.data!.accesToken!);
            StorageService().saveToken(type: Token.refresh.name, token: model.data!.refreshToken!);
            Navigator.pushReplacementNamed(ContextService.key.currentContext!, '/home');
          } else {
            throw ("unable to register");
          }
        } else {
          throw (model.message ?? "And even we don't rly know what :) Sorry for that");
        }
      }
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
  }
}
