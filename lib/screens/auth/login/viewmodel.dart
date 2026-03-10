import 'package:client/api_modules/body/body.dart';
import 'package:client/services/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api_modules/auth/auth.dart';
import '../../../enums/tokens.dart';
import '../../../services/context.dart';
import '../../../services/storage.dart';

class LoginViewModel extends ChangeNotifier {
  String email = "";
  String passoword = "";

  Future<void> silentLogin() async {
    final response = await ApiService().get(path: "ping");
    if (response.toString() == "pong" && await StorageService().isLoggedIn()) {
      Navigator.pushReplacementNamed(ContextService.key.currentContext!, '/home');
    }
  }

  Future<void> loginUser() async {
    try {
      Map<String, dynamic> body = {"email": email, "password": passoword};

      final Response<dynamic>? response = await ApiService().post(path: "auth/login", body: body);
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
            throw ("unable to login");
          }
        } else {
          throw (model.message ?? "And even we don't rly know what :) Sorry for that");
        }
      }
    } catch (error) {
      ApiService().somethingWentWrong(error);
    }
  }
}
