import 'package:client/enums/tokens.dart';
import 'package:client/services/api.dart';
import 'package:client/services/context.dart';
import 'package:client/services/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api_modules/auth/auth.dart';
import '../../../api_modules/body/body.dart';

class RegisterviewModel extends ChangeNotifier {
  String login = "";
  String email = "";
  String passoword = "";

  Future<void> registerUser() async {
    try {
      Map<String, dynamic> body = {"username": login, "email": email, "password": passoword};

      final Response<dynamic>? response = await ApiService().post(path: "auth/register", body: body);
      if (response != null) {
        final model = Body<Auth>.fromJson(response.data, (json) => Auth.fromJson(json as Map<String, dynamic>));

        if (model.success) {
          if (model.data != null) {
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
      ApiService().somethingWentWrong(error);
    }
  }
}
