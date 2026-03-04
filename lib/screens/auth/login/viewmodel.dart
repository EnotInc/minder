import 'package:client/api_modules/body/body.dart';
import 'package:client/services/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api_modules/auth/auth.dart';
import '../../../services/context.dart';
import '../../../services/storage.dart';

class LoginViewModel extends ChangeNotifier {
  String email = "";
  String passoword = "";

  Future<void> silentLogin() async {
    if (await StorageService().isLoggedIn()) {
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
            StorageService().saveToken(type: "access", token: model.data!.accesToken);
            StorageService().saveToken(type: "refresh", token: model.data!.refreshToken);
            Navigator.pushReplacementNamed(ContextService.key.currentContext!, '/home');
          } else {
            throw ("token is null");
          }
        } else {
          //TODO: replace with alert dialog
          print(model.message ?? "some error");
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
